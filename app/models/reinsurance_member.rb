class ReinsuranceMember < ApplicationRecord
  belongs_to :reinsurance
  belongs_to :member
  has_many :reinsurance_batches
  has_many :batches, class_name: "LoanInsurance::Batch", through: :reinsurance_batches


  def sum_loan_amount
    # self.reinsurance_batches.joins(:batch).sum(:loan_amount)
    self.batches.sum(:loan_amount)
  end
end
