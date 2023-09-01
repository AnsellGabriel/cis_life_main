class AddStatusToLoanInsuranceBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_insurance_batches, :status, :integer
  end
end
