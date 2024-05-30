class AddReferenceIdToLoanInsuranceBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_insurance_batches, :reference_id, :string
    add_column :loan_insurance_batches, :system_premium, :decimal, precision: 10, scale: 2
  end
end
