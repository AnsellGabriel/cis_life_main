class LoanInsurance::Batch < Batch
  self.table_name = "loan_insurance_batches"

  # skip agreement_benefit validation
  validate :agreement_benefit, unless: :skip_validation

  belongs_to :group_remit
  belongs_to :loan, class_name: 'LoanInsurance::Loan', foreign_key: 'loan_insurance_loan_id'
  belongs_to :rate, class_name: 'LoanInsurance::Rate', foreign_key: 'loan_insurance_rate_id'
  belongs_to :retention, class_name: 'LoanInsurance::Retention', foreign_key: 'loan_insurance_retention_id'
  has_many :details, class_name: 'LoanInsurance::Detail'
  
  private

  def skip_validation
    true 
  end
end
