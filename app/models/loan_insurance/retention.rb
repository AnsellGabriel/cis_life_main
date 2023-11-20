class LoanInsurance::Retention < ApplicationRecord
  has_many :details, class_name: "LoanInsurance::Detail"
  has_many :batches, class_name: "LoanInsurance::Batch", foreign_key: "loan_insurance_retention_id"
end
