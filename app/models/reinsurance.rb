class Reinsurance < ApplicationRecord
  has_many :reinsurance_batches
  has_many :batches, class_name: "LoanInsurance::Batch", foreign_key: "group_remit_id", dependent: :destroy, through: :reinsurance_batches


  def set_total_prem_and_amount
    self.update(
      ri_total_amount: self.batches.sum(:loan_amount),
      ri_total_prem: self.batches.sum(:premium_due)
    )
  end

  def get_batches
    self.batches
  end

  # def set_batches_ri_date
  #   self.reinsurance_batches.each do |batch|
  #     prev_ri = batch.reinsurance_batches.find_by(batch: batch)
  #   end
  # end

  def count_batches
    self.batches.count
  end
end
