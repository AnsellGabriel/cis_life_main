class LoanInsurance::Detail < ApplicationRecord
  belongs_to :batch, class_name: "LoanInsurance::Batch"
  belongs_to :loan, class_name: "LoanInsurance::Loan", foreign_key: "loan_insurance_loan_id"
  belongs_to :rate, class_name: "LoanInsurance::Rate", foreign_key: "loan_insurance_rate_id"
  belongs_to :retention, class_name: "LoanInsurance::Retention", foreign_key: "loan_insurance_retention_id"

  validates_presence_of :loan_amount, :premium_due, :terms, :date_release, :date_mature
end
