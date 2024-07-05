class AddServiceFeeToTreasuryCashierEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :treasury_cashier_entries, :service_fee, :decimal, precision: 15, scale: 2
    add_column :treasury_cashier_entries, :deposit, :decimal, precision: 15, scale: 2
  end
end
