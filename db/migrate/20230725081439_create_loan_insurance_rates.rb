class CreateLoanInsuranceRates < ActiveRecord::Migration[7.0]
  def change
    create_table :loan_insurance_rates do |t|
      t.integer :min_age
      t.integer :max_age
      t.decimal :monthly_rate, precision: 5, scale: 2
      t.decimal :annual_rate, precision: 5, scale: 2
      t.decimal :daily_rate, precision: 5, scale: 2

      t.timestamps
    end
  end
end
