class AddExcessToLoanInsuranceBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_insurance_batches, :excess, :decimal, precision: 10, scale: 2, default: 0
  end
end
