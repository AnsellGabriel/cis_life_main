class LoanInsurance::Loan < ApplicationRecord
  belongs_to :cooperative
  has_many :details, class_name: 'LoanInsurance::Detail'

end
