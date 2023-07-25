class CreateLoanInsuranceDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :loan_insurance_details do |t|
      t.references :batch, null: false, foreign_key: true
      t.decimal :unuse, precision: 10, scale: 2
      t.decimal :loan_amount, precision: 10, scale: 2
      t.decimal :premium_due, precision: 10, scale: 2
      t.decimal :substandard_rate, precision: 10, scale: 2
      t.boolean :terminated
      t.date :terminate_date
      t.boolean :reinsurance
      t.integer :terms
      t.date :date_release
      t.date :date_mature

      t.timestamps
    end
  end
end
