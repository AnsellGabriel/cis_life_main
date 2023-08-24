class ChangeColumnNameInLoanInsuranceBatches < ActiveRecord::Migration[7.0]
  def change
    rename_column :loan_insurance_batches, :coop_fee, :coop_sf_amount
    rename_column :loan_insurance_batches, :agent_fee, :agent_sf_amount
  end
end
