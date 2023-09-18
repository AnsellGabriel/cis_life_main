class GroupRemit < ApplicationRecord
  before_destroy :delete_associated_batches

  validates_presence_of :name #, :effectivity_date, :expiry_date, :terms

  scope :batch_remits, -> { where(:type => 'BatchRemit')}
  scope :loan_remits, -> { where(:type => 'LoanInsurance::GroupRemit')}

  belongs_to :agreement
  belongs_to :anniversary, optional: true
  has_many :batch_group_remits
  has_many :batches, through: :batch_group_remits
  has_many :denied_members, dependent: :destroy
  has_many :payments, dependent: :destroy
  # has_many :loan_batches, dependent: :destroy, class_name: 'LoanInsurance::Batch'
  has_one :process_coverage, dependent: :destroy
  has_one :group_import_tracker, dependent: :destroy
  accepts_nested_attributes_for :payments

  enum status: {
    pending: 0,
    under_review: 1,
    for_payment: 2,
    payment_verification: 3,
    paid: 4,
    for_renewal: 5,
    expired: 6,
    with_pending_members: 7,
    with_substandard_members: 8
  }

  def to_s
    name
  end

  #* group remit renewal
  def renew(current_user)
    new_group_remit = self.dup
    new_group_remit.set_terms_and_expiry_date(self.expiry_date + 1.year)
    # new_group_remit.expiry_date = self.expiry_date + 1.year # Assuming the renewal duration is 1 year from the current date
    new_group_remit.status = :for_renewal
    new_group_remit.type = "Remittance"
    new_group_remit.name = "#{self.name} Renewal"
    new_group_remit.batch_remit_id = self.id
    self.status = :for_renewal
    self.set_terms_and_expiry_date(self.expiry_date + 1.year)
    self.save!
    # new_group_remit.effectivity_date = self.effectivity_date + 1.year
    new_group_remit.save!

    agreement = new_group_remit.agreement

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
          user_type: 'CoopUser',
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

  #* group remit creation
  def self.process_group_remit(group_remit, anniversary_date, anniv_id, terms = nil)
    group_remit.set_terms_and_expiry_date(anniversary_date)
    agreement = group_remit.agreement

    if agreement.anniversary_type == 'multiple' || agreement.anniversary_type == 'single'
      group_remit.anniversary_id = params[:anniversary_id]
    end

    set_group_remit_names_and_terms(group_remit, terms)
  end

  def self.set_group_remit_names_and_terms(group_remit, terms = nil)
    remit_name = group_remit.instance_of?(BatchRemit) ? 'BATCH' : 'REMITTANCE'
    agreement = group_remit.agreement

    if agreement.is_term_insurance?
      group_remit.terms = terms
      group_remit.name = "#{agreement.moa_no} #{group_remit.effectivity_date.strftime('%B').upcase} #{remit_name} - #{group_remit.terms} MONTHS"
    elsif agreement.anniversary_type == 'none' or agreement.anniversary_type.nil?
      group_remit.name = "#{agreement.moa_no} #{group_remit.effectivity_date.strftime('%B').upcase} #{remit_name}"
    else
      group_remit.name = "#{agreement.moa_no} #{remit_name}"
    end
  end

  def set_total_premiums_and_fees
    self.gross_premium = gross_premium
    self.coop_commission = total_coop_commissions
    self.agent_commission = total_agent_commissions
    self.net_premium = net_premium

    unless self.type == 'BatchRemit'
      self.status = :for_payment
    end

    self.save!
    # self.effectivity_date = Date.today
  end

  def set_for_payment_status
    set_total_premiums_and_fees

    self.status = :for_payment
    self.save!
  end

  def set_under_review_status
    # set_total_premiums_and_fees
    self.status = :under_review
    self.save!
  end

  def approve_insurance_status_of_batches
    self.batches.update_all(insurance_status: :approved)
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

  def total_dependent_premiums
    batches.includes(:batch_dependents).sum {|batch| batch.batch_dependents.approved.sum(&:premium) }
  end

  def dependent_coop_commissions
    batches.approved.includes(:batch_dependents).sum {|batch| batch.batch_dependents.approved.sum(&:coop_sf_amount) }
  end

  def dependent_agent_commissions
    batches.approved.includes(:batch_dependents).sum {|batch| batch.batch_dependents.approved.sum(&:agent_sf_amount) }
  end

  def total_principal_premium
    if self.class.name == 'LoanInsurance::GroupRemit'
      loan_batches.sum(:premium_due)
    else
      batches.sum(&:premium)
    end
  end

  def denied_principal_premiums
    if self.class.name == 'LoanInsurance::GroupRemit'
      loan_batches.denied.sum(&:premium_due)
    else
      batches.denied.sum(&:premium)
    end
  end

  def denied_dependent_premiums
    (batches.denied.includes(:batch_dependents).sum {|batch| batch.batch_dependents.sum(&:premium) }) +
    (batches.where.not(insurance_status: :denied).includes(:batch_dependents).sum {|batch| batch.batch_dependents.denied.sum(&:premium) })
  end

  def gross_premium
    total_principal_premium + total_dependent_premiums
  end

  def coop_commissions
    batches.approved.sum(:coop_sf_amount)
  end

  def total_coop_commissions
    coop_commissions + dependent_coop_commissions
  end

  def total_agent_commissions
    agent_commissions + dependent_agent_commissions
  end

  def agent_commissions
    batches.approved.sum(:agent_sf_amount)
  end

  def coop_net_premium
    (gross_premium - total_coop_commissions ) - (denied_principal_premiums + denied_dependent_premiums)
  end

  def net_premium
    (gross_premium - (total_coop_commissions + total_agent_commissions) ) - (denied_principal_premiums + denied_dependent_premiums)
  end

  def batches_without_beneficiaries
    batches.where.not(id: self.batches.joins(:batch_beneficiaries).select(:id))
  end

  def batches_without_health_dec
    batches.recent.where.not(id: self.batches.joins(:batch_health_decs).select(:id))
  end

  def all_batches_have_beneficiaries?
    batches.all? { |batch| batch.batch_beneficiaries.exists? }
  end

  def set_terms_and_expiry_date(anniversary_date)
    plan = self.agreement.plan.acronym
    anniversary_type = self.agreement.anniversary_type

    if anniversary_type == 'none' or anniversary_type.nil?
      self.terms = 12
      self.effectivity_date = Date.today.beginning_of_month
      self.expiry_date = anniversary_date
    elsif plan == 'PMFC'
      self.effectivity_date = Date.today.beginning_of_month
    else
      terms = set_terms(anniversary_date)
      self.terms = terms < 0 ? terms + 12 : terms
      self.effectivity_date = Date.today
      self.expiry_date = terms < 0 ? anniversary_date.next_year : anniversary_date

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

  private

  def delete_associated_batches
    batches.each do |batch|
      agreement = self.agreement
      coop_member = batch.coop_member
      agreement.coop_members.delete(coop_member) if batch.status == 'recent'
      batch.batch_group_remits.destroy_all
      batch.destroy!
    end
  end
end
