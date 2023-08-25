class LoanInsurance::GroupRemit < GroupRemit
  validates :type, inclusion: { in: ['LoanInsurance::GroupRemit'], message: 'is not valid' }

  has_many :lppi_batches, class_name: "LoanInsurance::Batch", foreign_key: "group_remit_id", dependent: :destroy
end
