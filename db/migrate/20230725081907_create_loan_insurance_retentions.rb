class CreateLoanInsuranceRetentions < ActiveRecord::Migration[7.0]
  def change
    create_table :loan_insurance_retentions do |t|
      t.decimal :amount, precision: 15, scale: 2
      t.boolean :active
      t.date :date_activated
      t.date :date_deactivated

      t.timestamps
    end
  end
end
