class AddProcessClaimToLoanInsuranceBatches < ActiveRecord::Migration[7.0]
  def change
    add_reference :loan_insurance_batches, :process_claim, foreign_key: true
  end
end
