#class CreateTreasuryCashierEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :treasury_cashier_entries do |t|
      t.integer :or_no
      t.date :or_date
      t.references :entriable, polymorphic: true#, null: false
      t.integer :payment
      t.integer :status, default: 0
      t.references :treasury_account, null: false, foreign_key: true
      t.decimal :amount, precision: 15, scale: 2

      t.timestamps
    end
  end
end
