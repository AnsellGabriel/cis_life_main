class AddInsuranceStatusToLoanInsuranceBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_insurance_batches, :insurance_status, :integer
  end
end
