class LoanInsurance::Batch < Batch
  has_many :details, class_name: 'LoanInsurance::Detail'
end
