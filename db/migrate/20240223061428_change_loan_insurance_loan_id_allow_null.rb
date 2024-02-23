class ChangeLoanInsuranceLoanIdAllowNull < ActiveRecord::Migration[7.0]
  def change
    change_column :loan_insurance_batches, :loan_insurance_loan_id, :bigint, null: true
  end
end
