class CreateLoanInsuranceRates < ActiveRecord::Migration[7.0]
  def change
    create_table :loan_insurance_rates do |t|
      t.integer :min_age
      t.integer :max_age
      t.decimal :monthly_rate
      t.decimal :annual_rate
      t.decimal :daily_rate

      t.timestamps
    end
  end
end
