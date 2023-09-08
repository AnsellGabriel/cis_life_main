class CreateTableLoanInsuranceBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :loan_insurance_batches do |t|
      t.references :coop_member, null: false, foreign_key: true
      t.references :group_remit, null: false, foreign_key: true
      t.integer :age
      t.date :effectivity_date
      t.date :expiry_date
      t.date :date_release
      t.date :date_mature
      t.integer :terms
      t.decimal :unused, precision: 10, scale: 2
      t.decimal :premium, precision: 10, scale: 2
      t.decimal :premium_due, precision: 10, scale: 2
      t.decimal :coop_fee, precision: 10, scale: 2
      t.decimal :agent_fee, precision: 10, scale: 2
      t.boolean :valid_health_dec, default: false
      t.decimal :loan_amount, precision: 10, scale: 2
      t.references :loan_insurance_rate, null: false, foreign_key: true
      t.boolean :reinsurance
      t.references :loan_insurance_retention, null: false, foreign_key: true

      t.timestamps
    end
  end
end
