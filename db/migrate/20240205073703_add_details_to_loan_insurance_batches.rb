class AddDetailsToLoanInsuranceBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_insurance_batches, :first_name, :string
    add_column :loan_insurance_batches, :middle_name, :string
    add_column :loan_insurance_batches, :last_name, :string
    add_column :loan_insurance_batches, :birthdate, :date
    add_column :loan_insurance_batches, :civil_status, :string
  end
end
