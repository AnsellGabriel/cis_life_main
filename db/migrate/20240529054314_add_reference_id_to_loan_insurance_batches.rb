class AddReferenceIdToLoanInsuranceBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_insurance_batches, :reference_id, :string
  end
end
