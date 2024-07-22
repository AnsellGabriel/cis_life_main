class CreateGeneralLedgers < ActiveRecord::Migration[7.0]
  def change
    create_table :general_ledgers do |t|
      t.references :ledgerable, polymorphic: true#, null: false
      t.references :account, null: false, foreign_key: { to_table: :treasury_accounts }
      t.text :description
      t.integer :ledger_type
      t.decimal :amount, default: 0, precision: 15, scale: 2

      t.timestamps
    end
  end
end
