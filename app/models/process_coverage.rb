class ProcessCoverage < ApplicationRecord
  attr_accessor :premium
  belongs_to :group_remit
  belongs_to :agent, optional: true
  belongs_to :processor, class_name: "Employee"
  belongs_to :approver, class_name: "Employee"
  has_many :process_remarks

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

  enum und_route: {
    for_analyst_review: 0,
    for_head_review: 1,
    for_vp_review: 2,
    pc_approved: 3,
    pc_denied: 4,
    pc_reprocessed: 5
  }

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

  def get_plan
    self.group_remit.agreement.plan
  end

  # def set_batches_for_review
  #   self.group_remit.batches.each do |batch|
  #     batch.update_attribute(:insurance_status, :for_review)
  #   end
  # end
  
end
