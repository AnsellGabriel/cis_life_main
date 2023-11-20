class AddStatusToTreasuryCashierEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :treasury_cashier_entries, :status, :integer, default: 0
  end
end
