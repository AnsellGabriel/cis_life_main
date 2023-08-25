class LoanInsurance::Loan < ApplicationRecord
  before_save :capitalize_name

  belongs_to :cooperative
  has_many :details, class_name: 'LoanInsurance::Detail'
  has_many :batches, class_name: 'LoanInsurance::Batch', foreign_key: 'loan_insurance_loan_id'

  private

  def capitalize_name
    self.name = self.name.upcase
  end
end
