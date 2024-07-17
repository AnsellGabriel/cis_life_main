class AddVatColumnsToTreasuryCashierEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :treasury_cashier_entries, :vatable_amount, :decimal, precision: 15, scale: 2, default: 0
    change_column :treasury_cashier_entries, :amount, :decimal, default: 0, precision: 15, scale: 2
    add_column :treasury_cashier_entries, :insurance, :boolean, default: false
    add_column :treasury_cashier_entries, :discounted, :boolean, default: false
  end
end
