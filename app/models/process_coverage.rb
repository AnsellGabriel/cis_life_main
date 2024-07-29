class ProcessCoverage < ApplicationRecord
  attr_accessor :premium, :loan_amount, :payment_type

  belongs_to :group_remit

  belongs_to :agent, optional: true

  belongs_to :processor, class_name: "Employee", optional: true
  belongs_to :approver, class_name: "Employee", optional: true
  belongs_to :team, optional: true

  belongs_to :who_processed, class_name: "Employee", optional: true
  belongs_to :who_approved, class_name: "Employee", optional: true
  has_many :process_remarks
  has_many :notifications
  has_one :voucher_request, as: :requestable, dependent: :destroy, class_name: "Accounting::VoucherRequest"

  has_many :transmittable_ors, as: :transmittable, inverse_of: :transmittable
  has_many :transmittals, through: :transmittable_ors

  delegate :cooperative, to: :group_remit


  # audited
  # has_associated_audits


  enum status: {
    for_process: 0,
    pending: 1,
    approved: 2,
    denied: 3,
    for_head_approval: 4,
    for_vp_approval: 5,
    reprocess: 6, # done reprocessing
    reprocess_approved: 7, # able to reprocess by UA
    reprocess_request: 9, # UA request to reprocess
    reconsiderations_processed: 8,
    reassess: 10 # Reaassessment
  }
  FILTERED_STATUSES = statuses.select { |key, value| [0, 2, 3, 10].include?(value) }.keys

  STATUSES = [["All", 0], ["FOR PROCESS", 1], ["PROCESSED", 3]]

  PCS = ProcessCoverage.where(status: :approved)

  enum und_route: {
    for_analyst_review: 0,
    for_head_review: 1,
    for_vp_review: 2,
    pc_approved: 3,
    pc_denied: 4,
    pc_reprocessed: 5
  }

  def to_s
    self.group_remit.name
  end

  def for_transmittal
    "#{group_remit.agreement.plan.acronym}#{id} - #{group_remit.agreement.cooperative}"
  end

  def set_default_attributes
    self.status = :for_process
    self.approved_count = 0
    self.approved_total_coverage = 0
    self.approved_total_prem = 0
    self.denied_count = 0
    self.denied_total_coverage = 0
    self.denied_total_prem = 0

    # self.set_batches_for_review
  end

  def count_members(type)
    case type
    when "denied" then group_remit.batches.where(insurance_status: :denied).count
    when "approved" then group_remit.batches.where(insurance_status: :approved).count
    when "pending" then group_remit.batches.where(insurance_status: :pending).count
    when "for_review" then group_remit.batches.where(insurance_status: :for_review).count
    end
  end

  def get_batch_dep(i_type, type)
    case i_type
      # when 1 then self.group_remit.batches.joins(:batch_dependents).where(batch_dependents: { agreement_benefit: type.id }).count
      # when 1 then self.group_remit.batches.where(agreement_benefit: type.id).count
      # when 2..5 then self.group_remit.batches.where(agreement_benefit: type.id).count
    when 2..5 then self.group_remit.batches.joins(:batch_dependents).where(batch_dependents: { agreement_benefit: type.id }).count
    else
      self.group_remit.batches.where(agreement_benefit: type.id).count
    end
  end

  def count_approved(i_type, type)
    case i_type
    when 2..5 then self.group_remit.batches.joins(:batch_dependents).where(batch_dependents: { agreement_benefit: type.id }, insurance_status: "approved").count
    else
      self.group_remit.batches.where(agreement_benefit: type.id, insurance_status: "approved").count
    end
  end

  def count_denied(i_type, type)
    case i_type
    when 2..5 then self.group_remit.batches.joins(:batch_dependents).where(batch_dependents: { agreement_benefit: type.id }, insurance_status: "denied").count
    else
      self.group_remit.batches.where(agreement_benefit: type.id, insurance_status: "denied").count
    end
  end

  def count_pending(i_type, type)
    case i_type
    when 2..5 then self.group_remit.batches.joins(:batch_dependents).where(batch_dependents: { agreement_benefit: type.id }, insurance_status: "pending").count
    else
      self.group_remit.batches.where(agreement_benefit: type.id, insurance_status: "pending").count
    end
  end

  def get_plan_acronym
    self.group_remit.agreement.plan.acronym
  end

  def get_plan
    self.group_remit.agreement.plan
  end

  def count_regular_batches(age_range)
    self.group_remit.batches.where(age: age_range).count
  end

  def count_overage_batches
    self.group_remit.batches.where(age: 66..).count
  end

  def sum_batches_loan_amount
    self.group_remit.batches.where(insurance_status: :approved).sum(:loan_amount)
  end

  def sum_batches_service_fee
    group_remit.batches.where(insurance_status: :approved).sum(:coop_sf_amount)
  end

  def sum_denied_batches_prem
    group_remit.batches.where(insurance_status: :denied).sum(:premium).to_f
  end

  def sum_denied_batches_sf
    group_remit.batches.where(insurance_status: :denied).sum(:coop_sf_amount).to_f
  end

  def sum_denied_cov(denied_batches)
    case group_remit.type
    when "LoanInsurance::GroupRemit"
      group_remit.batches.where(insurance_status: :denied).sum(:loan_amount)
    else
      ProductBenefit.joins(agreement_benefit: :batches).where("batches.id IN (?)", denied_batches.pluck(:id)).where("product_benefits.benefit_id = ?", 1).sum(:coverage_amount)
    end
  end

  def sum_batches_gross_prem(klass)
    case klass
    when "LoanInsurance::Batch"
      self.group_remit.batches.where(loan_insurance_batches: {insurance_status: :approved}).sum(:premium).to_d
    else
      self.group_remit.batches.where(batches: {insurance_status: :approved}).sum(:premium).to_d + self.group_remit.batches_dependents_approved_prem.sum(:premium)
    end
  end

  def sum_batches_net_premium # gyrt
    self.group_remit.batches.where(insurance_status: :approved).sum(:premium) - (self.group_remit.batches.where(insurance_status: :approved).sum(:coop_sf_amount) + self.group_remit.batches.where(insurance_status: :approved).sum(:agent_sf_amount))
  end

  def count_batches(status)
    case status
    when "approved"
      self.group_remit.batches.where(insurance_status: :approved).count
    when "denied"
      self.group_remit.batches.where(insurance_status: :denied).count
    end
  end


  def count_batches_denied(klass)
    case klass
    when "LoanInsurance::Batch"
      self.group_remit.batches.where(loan_insurance_batches: { insurance_status: :denied} ).count
    else
      self.group_remit.batches.where(batches: { insurance_status: :denied} ).count
    end
  end

  def count_batches_approved(klass)
    case klass
    when "LoanInsurance::Batch"
      self.group_remit.batches.where(loan_insurance_batches: { insurance_status: :approved} ).count
    else
      self.group_remit.batches.where(batches: { insurance_status: :approved} ).count
    end
  end

  def count_pending_for_review_batches(klass)
    case klass
    when "LoanInsurance::Batch"
      self.group_remit.batches.where(loan_insurance_batches: { insurance_status: [:for_review, :pending] }).count
    else
      self.group_remit.batches.where(batches: { insurance_status: [:for_review, :pending] }).count
    end
  end

  def count_pending_for_review_dep(klass)
    count = 0
    self.group_remit.batches.each do |batch|
      count += batch.batch_dependents.where(insurance_status: [:for_review, :pending]).count
    end
    return count
  end

  def get_batch_class_name
    self.group_remit.batches.first.class.name
  end

  def get_batches
    self.group_remit.batches
  end

  def get_or_number
    # self.group_remit.payments.first.nil? ? "-" : self.group_remit.payments.first.entries.first.or_no
    approved_payments = self.group_remit.payments.approved
    approved_payments.first.nil? ? "-" : approved_payments.first.entries.first&.or_no
  end

  def get_or_date
    # self.group_remit.payments.first.nil? ? "-" : self.group_remit.payments.first.entries.first.or_date
    approved_payments = self.group_remit.payments.approved
    approved_payments.first.nil? ? "-" : approved_payments.first.entries.first&.or_date
  end


  def get_principal_prem
    prem = self.group_remit.batches.where(insurance_status: "approved").sum(:premium)
    coop_sf = self.group_remit.batches.where(insurance_status: "approved").sum(:coop_sf_amount)
    agent_sf = self.group_remit.batches.where(insurance_status: "approved").sum(:agent_sf_amount)

    prem - (coop_sf + agent_sf)
  end

  def get_lppi_effective
    self.group_remit.batches.order(effectivity_date: :asc).pluck(:effectivity_date).first
  end

  def get_lppi_expiry
    self.group_remit.batches.order(expiry_date: :asc).pluck(:expiry_date).last
  end
  

  def self.index_cov_list(approver_id, status, date_range)
    # joins(group_remit: { agreement: { emp_agreements: {employee: :emp_approver} } }).where( emp_approver: { approver_id: approver_id }, emp_agreements: { active: true}).where(status: status, created_at: date_range)
    # where(status: status, created_at: date_range, approver_id: approver_id)
    where(status: status, created_at: date_range)
  end

  def self.cov_list_analyst(user, status=nil, type=nil)
    case type
    when nil
      where(processor: nil, status: status, team: user.team) 
      # where(team: user.team, status: status)
    when "process"
      # where(processor: user, status: ["approved", "denied"])
      where(status: ["approved", "denied"]).where(arel_pcs[:who_approved_id].eq(user.id).or(arel_pcs[:who_processed_id].eq(user.id).and(arel_pcs[:who_approved_id].not_eq(nil))))
      # where(team: user.team, status: ["approved", "denied"])
    when "eval"
      # where(processor: user, status: ["for_head_approval", "for_vp_approval"])
      where(team: user.team, status: ["for_head_approval", "for_vp_approval"])
    when "selected"
      where(processor: user, status: ["for_process", "pending"])
    when "approved"
      where(status: :approved).where(arel_pcs[:who_approved_id].eq(user.id).or(arel_pcs[:who_processed_id].eq(user.id).and(arel_pcs[:who_approved_id].not_eq(nil))))
    when "denied"
      where(status: :denied).where(arel_pcs[:who_approved_id].eq(user.id).or(arel_pcs[:who_processed_id].eq(user.id).and(arel_pcs[:who_approved_id].not_eq(nil))))
    when "pending"
      where(status: :for_process, processor: user)
    when "for_process"
      where(status: ["for_process", "pending"], processor: user)
    end
  end

  def self.for_head_approvals(user)
    case user.rank
    when "head"
      where(status: :for_head_approval, approver_id: user.userable_id)
    when "senior_officer"
      where(status: :for_head_approval)
    end
  end

  def self.for_vp_approvals(user)
    where(status: :for_vp_approval)
  end

  def check_approver
    self.process_date == nil && self.evaluate_date != nil
  end

  # def set_batches_for_review
  #   self.group_remit.batches.each do |batch|
  #     batch.update_attribute(:insurance_status, :for_review)
  #   end
  # end

  
  def self.to_csv
    attributes = %w{id cooperative plan marketing gross_premium coop_service_fee agent_commission net_premium region processor}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |pc|
        csv << attributes.map{ |attr| pc.send(attr) }
      end
    end
  end

  def self.get_reports(type, date_from, date_to, user_id=nil)
    case type
    when 0 # ALL status
      where(created_at: date_from..date_to).order(:created_at)
    when 1 # UNPROCESSED
      where(status: :for_process, created_at: date_from..date_to).order(:created_at)
    when 2 # PROCESSED
      where(status: [:approved, :denied], created_at: date_from..date_to).order(:created_at)
    end

  end

  def self.arel_pcs
    arel_table
  end

end
