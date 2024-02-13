class GroupRemit < ApplicationRecord
  include SubstringExtractor

  before_destroy :delete_associated_batches

  validates_presence_of :name # , :effectivity_date, :expiry_date, :terms

  scope :batch_remits, -> { where(:type => "BatchRemit")}
  scope :loan_remits, -> { where(:type => "LoanInsurance::GroupRemit")}
  scope :remittances, -> { where(:type => "Remittance")}

  belongs_to :agreement
  belongs_to :anniversary, optional: true

  has_many :batch_group_remits
  has_many :batches, through: :batch_group_remits
  has_many :denied_members, dependent: :destroy
  has_many :payments, as: :payable, dependent: :destroy
  has_many :loan_batches, dependent: :destroy, class_name: "LoanInsurance::Batch"
  has_many :cashier_entries, as: :entriable, class_name: "Treasury::CashierEntry", dependent: :destroy

  has_one :process_coverage, dependent: :destroy
  # has_one :group_import_tracker, dependent: :destroy
  has_one :progress_tracker, as: :trackable, dependent: :destroy
  accepts_nested_attributes_for :payments

  delegate :cooperative, to: :agreement

  enum status: {
    pending: 0,
    under_review: 1,
    for_payment: 2,
    payment_verification: 3,
    paid: 4,
    for_renewal: 5,
    expired: 6,
    with_pending_members: 7,
    with_substandard_members: 8,
    reupload_payment: 9
  }

  enum refund_status: {
    not_refunded: 0,
    ready_for_refund: 1,
    refunded: 2
  }

  def to_s
    name
  end

  # * group remit renewal
  def renew(current_user)
    new_group_remit = self.dup
    new_group_remit.set_terms_and_expiry_date(self.expiry_date + 1.year)
    # new_group_remit.expiry_date = self.expiry_date + 1.year # Assuming the renewal duration is 1 year from the current date
    new_group_remit.status = :for_renewal
    new_group_remit.type = "Remittance"
    # new_group_remit.name = "#{GroupRemit.extract_from_substring(self.name, ('GYRT' or 'LPPI'))} RENEWAL"
    new_group_remit.name = "#{self.name} RENEWAL"
    new_group_remit.batch_remit_id = self.id
    self.status = :for_renewal
    self.set_terms_and_expiry_date(self.expiry_date + 1.year)
    self.save!
    # new_group_remit.effectivity_date = self.effectivity_date + 1.year
    new_group_remit.save!

    # agreement = new_group_remit.agreement

    removed_batches = [] # To store the batches that are removed from the renewal

    self.batches.includes(coop_member: :member).approved.each do |batch|
      existing_coverage = agreement.agreements_coop_members.find_by(coop_member_id: batch.coop_member.id)

      new_batch = Batch.new(coop_member_id: batch.coop_member.id)
      new_batch.previous_effectivity_date = batch.effectivity_date
      new_batch.previous_expiry_date = batch.expiry_date
      b_rank = batch.agreement_benefit

      Batch.process_batch(
        new_batch,
        new_group_remit,
        b_rank,
        new_group_remit.terms
      )

      new_group_remit.batches << new_batch

      if new_batch.member_details.age(new_group_remit.effectivity_date) >= new_batch.agreement_benefit.exit_age
        new_batch.insurance_status = :denied
        new_batch.batch_remarks.build(
          remark: "Member age is over the maximum age limit of the plan.",
          status: :denied,
          user_type: "CoopUser",
          user_id: current_user.userable.id
        )
      else
        new_batch.insurance_status = :for_review
      end

      new_batch.save!

      if batch.batch_dependents.present?
        batch.batch_dependents.each do |dependent|
          new_dependent = dependent.dup
          new_dependent.batch_id = new_batch.id
          new_dependent.set_premium_and_service_fees(dependent.agreement_benefit, new_group_remit)
          new_dependent.save!
        end
      end

      batch.batch_beneficiaries.each do |beneficiary|
        new_beneficiary = beneficiary.dup
        new_beneficiary.batch_id = new_batch.id
        new_beneficiary.save!
      end
    end

    renewal_result = {
      new_group_remit: new_group_remit,
      removed_batches: removed_batches
    }
  end

  # * group remit creation
  def self.process_group_remit(group_remit, anniversary_date, anniv_id)
    group_remit.set_terms_and_expiry_date(anniversary_date)
    agreement = group_remit.agreement
    anniv_type = agreement.anniversary_type

    if anniv_type.downcase == "multiple" || anniv_type.downcase == "single"
      group_remit.anniversary_id = anniv_id
    end

    set_group_remit_names_and_terms(group_remit)
  end

  def self.set_group_remit_names_and_terms(group_remit)
    agreement = group_remit.agreement
    anniv_type = agreement.anniversary_type

    if (anniv_type.downcase == "12 months" or anniv_type.nil?) && group_remit.instance_of?(BatchRemit)
      # group_remit.name = "#{extract_from_substring(agreement.moa_no, ('GYRT' or 'LPPI'))} #{group_remit.effectivity_date.strftime('%B').upcase} BATCH"
      group_remit.name = "#{group_remit.effectivity_date.strftime('%B').upcase} BATCH"
    else
      # group_remit.name = "#{extract_from_substring(agreement.moa_no, ('GYRT' or 'LPPI'))} REMITTANCE #{agreement.group_remits.where(type: 'Remittance').size + 1}"
      group_remit.name = "REMITTANCE #{agreement.group_remits.where(type: 'Remittance').size + 1}"

    end

  end

  def set_for_payment_status
    set_total_premiums_and_fees

    self.status = :for_payment
    Notification.create(notifiable: self.agreement.cooperative, message: "#{self.name} is approved and now for payment.")
    self.save!
  end

  def set_under_review_status
    # set_total_premiums_and_fees
    self.status = :under_review
    self.save!
  end

  def approve_insurance_status_of_batches
    self.batches.where(insurance_status: :for_review).update_all(insurance_status: :approved)
  end

  def coop_member_ids
    batches.pluck(:coop_member_id)
  end

  def batches_dependents
    BatchDependent.joins(batch: :group_remits)
      .where(group_remits: {id: self.id})
  end

  def batches_dependents_approved_prem
    BatchDependent.joins(batch: :group_remits)
      .where(group_remits: {id: self.id}, batch: { insurance_status: :approved })
  end

  def set_premium(insured_type)
    agreement.agreement_benefits.find_by(insured_type: insured_type).product_benefits[0].premium
  end

  def get_coop_sf
    agreement.coop_sf
  end

  def get_agent_sf
    agreement.agent_sf
  end

  def set_total_premiums_and_fees
    self.gross_premium = commisionable_premium
    self.coop_commission = total_coop_commissions
    self.agent_commission = total_agent_commissions
    self.net_premium = net_premium

    unless self.type == "BatchRemit"

      if self.process_coverage.status == "approved"
        if self.mis_entry?
          self.status = :paid
          self.update_batch_remit
          self.update_batch_coverages

          # net_prem = initial_gross_premium - (denied_principal_premiums + denied_dependent_premiums)

          if self.gross_premium > approved_premiums
            self.refund_amount = (self.gross_premium - approved_premiums) - ((self.gross_premium - approved_premiums) * (agreement.coop_sf / 100))
          end

        else
          self.status = :for_payment
          Notification.create(notifiable: self.agreement.cooperative, message: "#{self.name} is approved and now for payment.")
        end
      else
        self.status.nil? ? "under_review" : self.status
      end
      # self.status = :for_payment
      # Notification.create(notifiable: self.agreement.cooperative, message: "#{self.name} is approved and now for payment.")
    end

    self.save!
    # self.effectivity_date = Date.today
  end

  def total_dependent_premiums
    if agreement.plan.acronym.include?("GYRT")
      batches.includes(:batch_dependents).sum {|batch| batch.batch_dependents.sum(:premium) }
    else
      0
    end
  end

  def dependent_coop_commissions
    if self.instance_of?(LoanInsurance::GroupRemit)
      0
    else
      batches.approved.includes(:batch_dependents).sum {|batch| batch.batch_dependents.approved.sum(&:coop_sf_amount) }
    end
  end

  def dependent_agent_commissions
    if agreement.plan.acronym.include?("GYRT")
      batches.approved.includes(:batch_dependents).sum {|batch| batch.batch_dependents.approved.sum(&:agent_sf_amount) }
    else
      0
    end
  end

  def total_principal_premium
    if self.instance_of?(LoanInsurance::GroupRemit)
      batches.sum(:premium_due)
    else
      batches.sum(:premium)
    end
  end

  def denied_principal_premiums
    if self.instance_of?(LoanInsurance::GroupRemit)
      batches.where.not(insurance_status: :approved).sum(:premium_due)
    else
      batches.where.not(insurance_status: :approved).sum(:premium)
    end
  end

  def denied_dependent_premiums
    if agreement.plan.acronym.include?("GYRT")
      (batches.where.not(insurance_status: :approved).includes(:batch_dependents).sum {|batch|
 batch.batch_dependents.sum(&:premium) }) + (batches.where(insurance_status: :approved).includes(:batch_dependents).sum {|batch|
 batch.batch_dependents.denied.sum(&:premium) })
    else
      0
    end
  end

  def initial_gross_premium
    total_principal_premium + total_dependent_premiums
  end

  def approved_premiums
    initial_gross_premium - denied_premiums
  end

  def denied_premiums
    denied_principal_premiums + denied_dependent_premiums
  end

  def commisionable_premium
    if self.mis_entry?
      initial_gross_premium
    else
      approved_premiums
    end
  end

  def coop_commissions
    batches.approved.sum(:coop_sf_amount)
  end

  def total_coop_commissions
    if agreement.coop_sf
        coop_commissions + dependent_coop_commissions
    else
      0
    end
  end

  def front_end_coop_commission
    if agreement.coop_sf
      commisionable_premium * (agreement.coop_sf / 100)
    else
      0
    end
  end

  def front_end_coop_net_premium
    commisionable_premium - front_end_coop_commission
  end

  def total_agent_commissions
    agent_commissions + dependent_agent_commissions
  end

  def agent_commissions
    batches.approved.sum(:agent_sf_amount)
  end

  def coop_net_premium
    commisionable_premium - (total_coop_commissions)
  end

  def net_premium
    (commisionable_premium - (total_coop_commissions + total_agent_commissions) ) - (denied_principal_premiums + denied_dependent_premiums)
  end

  def batches_without_beneficiaries
    batches.where.not(id: self.batches.joins(:batch_beneficiaries).select(:id))
  end

  def batches_without_health_dec
    # batches.recent.where.not(id: self.batches.joins(:batch_health_decs).select(:id))
    if self.agreement.plan.acronym.include?("LPPI")
      batches.recent.where.missing(:batch_health_decs).where.not(loan_amount: 0..agreement.nel)
    else
      batches.recent.where.missing(:batch_health_decs)
    end
  end

  def all_batches_have_beneficiaries?
    batches.all? { |batch| batch.batch_beneficiaries.exists? }
  end

  def set_terms_and_expiry_date(anniversary_date)
    plan = self.agreement.plan.acronym
    anniversary_type = self.agreement.anniversary_type

    if anniversary_type.downcase == "12 months" or anniversary_type.nil?
      self.terms = 12
      self.effectivity_date = Date.today.beginning_of_month
      self.expiry_date = anniversary_date
    else
      terms = set_terms(anniversary_date)
      self.terms = terms <= 0 ? terms + 12 : terms
      self.effectivity_date = Date.today
      self.expiry_date = terms <= 0 ? anniversary_date.next_year : anniversary_date

      if anniversary_date.day > Date.today.day
        self.terms += 1
      end

    end
  end

  def set_terms(anniversary_date)
    terms = (Date.today.year * 12 + anniversary_date.month) - (Date.today.year * 12 + Date.today.month)
  end

  def self.expiry_dates
    pluck(:expiry_date).map { |date| date.strftime("%m-%d") }
  end

  def batches_all_renewal?
    batches.all? { |batch| batch.status == "renewal" }
  end

  def update_batch_remit
    approved_batches = batches.approved
    # approved_members = CoopMember.approved_members(approved_batches)
    # current_batch_remit = batch_remit
    # duplicate_batches = current_batch_remit.batch_group_remits.existing_members(approved_members)

    BatchRemit.process_batch_remit(batch_remit, approved_batches)
  end

  def update_batch_coverages
    batches.where(insurance_status: :approved).includes(:coop_member).each do |batch|
      # agreement = self.agreement
      coop_member = batch.coop_member
      existing_coverage = agreement.agreements_coop_members.find_or_initialize_by(coop_member_id: coop_member.id)
      existing_coverage.status = batch.status
      existing_coverage.expiry = batch.expiry_date
      existing_coverage.effectivity = batch.effectivity_date
      existing_coverage.save!
    end
  end

  def approved_payment
    payments.approved.last
  end

  # def posted_or
  #   approved_payment.entries.posted.last
  # end

  def editable_by_mis?(current_user)
    (current_user.userable_type == "Employee" && current_user.userable.department_id == 15) && !self.instance_of?(BatchRemit) && self.pending?
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name", "or_number"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def or_number
    self.official_receipt
  end

  private

  def delete_associated_batches
    batches.each do |batch|
      agreement = self.agreement
      coop_member = batch.coop_member
      agreement.coop_members.delete(coop_member) if batch.status == "recent"
      batch.batch_group_remits.destroy_all
      batch.destroy!
    end
  end

  def batch_remit
    BatchRemit.find(self.batch_remit_id)
  end
end
