class CreateTreasuryBillingStatements < ActiveRecord::Migration[7.0]
  def change
    create_table :treasury_billing_statements do |t|
      t.integer :bs_no
      t.date :bs_date
      t.references :cashier_entry, null: false, foreign_key: { to_table: :treasury_cashier_entries }

      t.timestamps
    end
  end
end
