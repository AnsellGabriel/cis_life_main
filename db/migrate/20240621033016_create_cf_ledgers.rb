class CreateCfLedgers < ActiveRecord::Migration[7.0]
  def change
    create_table :cf_ledgers do |t|
      t.references :ledgerable, polymorphic: true#, null: false
      t.references :cf_account#, null: false, foreign_key: true
      t.integer :entry_type
      t.decimal :amount, precision: 18, scale: 2
      t.datetime :transaction_date

      t.timestamps
    end
  end
end
