class CreateGeneralLedgers < ActiveRecord::Migration[7.0]
  def change
    create_table :general_ledgers do |t|
      t.references :ledgerable, polymorphic: true, null: false
      t.text :description
      t.decimal :debit, default: 0, precision: 15, scale: 2
      t.decimal :credit, default: 0, precision: 15, scale: 2

      t.timestamps
    end
  end
end
