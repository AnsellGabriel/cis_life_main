class LoanInsurance::Rate < ApplicationRecord

  belongs_to :agreement
  has_many :batches, class_name: "LoanInsurance::Batch", foreign_key: "loan_insurance_rate_id"
  has_many :details, class_name: "LoanInsurance::Detail"


  # def self.get_rate(id)
  #   # .find_by(id: batch.loan_insurance_rate_id).monthly_rate
  # end
end
