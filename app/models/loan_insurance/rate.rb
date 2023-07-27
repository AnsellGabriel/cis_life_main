class LoanInsurance::Rate < ApplicationRecord
  has_many :details, class_name: 'LoanInsurance::Detail'

end
