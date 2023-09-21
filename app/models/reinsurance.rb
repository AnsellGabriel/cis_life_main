class Reinsurance < ApplicationRecord
  has_many :reinsurance_batches
  has_many :batches, class_name: "LoanInsurance::Batch", foreign_key: "group_remit_id", dependent: :destroy, through: :reinsurance_batches


  def set_total_prem_and_amount
    self.update(
      ri_total_amount: self.batches.sum(:loan_amount),
      ri_total_prem: self.batches.sum(:premium_due)
    )
  end

  def count_batches
    self.batches.count
  end
end
