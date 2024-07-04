class AddSystemUnusedToLoanInsuranceBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_insurance_batches, :system_unused, :decimal, precision: 15, scale: 2, default: 0.0
  end
end
