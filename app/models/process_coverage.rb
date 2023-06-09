class ProcessCoverage < ApplicationRecord
  belongs_to :group_remit
  belongs_to :agent, optional: true
  has_many :process_remarks

  enum status: {
    for_process: 0,
    pending: 1,
    approved: 2,
    denied: 3
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

  # def set_batches_for_review
  #   self.group_remit.batches.each do |batch|
  #     batch.update_attribute(:insurance_status, :for_review)
  #   end
  # end
  
end
