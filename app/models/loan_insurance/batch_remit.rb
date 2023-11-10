class LoanInsurance::BatchRemit < GroupRemit
  validate :validate_type


  private
  def validate_type
    # Check if the type attribute matches the expected value 'LoanInsurance::BatchRemit'
    if type != "LoanInsurance::BatchRemit"
      errors.add(:type, "must be 'LoanInsurance::BatchRemit'")
    end
  end

end
