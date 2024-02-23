class AddLoanToLoanInsuranceBatches < ActiveRecord::Migration[7.0]
  def change
    add_reference :loan_insurance_batches, :loan_insurance_loan
  end
end
