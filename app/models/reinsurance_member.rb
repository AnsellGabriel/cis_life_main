class ReinsuranceMember < ApplicationRecord
  belongs_to :reinsurance
  belongs_to :member
  has_many :reinsurance_batches
  has_many :batches, class_name: "LoanInsurance::Batch", through: :reinsurance_batches


  def sum_loan_amount
    # self.reinsurance_batches.joins(:batch).sum(:loan_amount)
    self.batches.sum(:loan_amount)
  end

  def sum_loan_amount_per_month(date_start, date_end)
    self.batches.where("(loan_insurance_batches.effectivity_date <= ? and loan_insurance_batches.expiry_date >= ?) OR (loan_insurance_batches.effectivity_date <= ? and loan_insurance_batches.expiry_date >= ?)", date_start, date_start, date_end, date_end).sum(:loan_amount)
  end
end
