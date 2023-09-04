class AddTerminatedToLoanInsuranceBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_insurance_batches, :terminated, :boolean
    add_column :loan_insurance_batches, :terminate_date, :date
  end
end
