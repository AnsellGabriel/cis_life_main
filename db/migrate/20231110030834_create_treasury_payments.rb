class CreateTreasuryPayments < ActiveRecord::Migration[7.0]
  def change
    create_table :treasury_payments do |t|
      t.integer :payment_type
      t.integer :check_no
      t.decimal :amount, precision: 15, scale: 2
      t.references :account, null: false, foreign_key: { to_table: :treasury_accounts }
      t.references :cashier_entry, null: false, foreign_key: { to_table: :treasury_cashier_entries }

      t.timestamps
    end
  end
end
