class ChangeColumnTypeInTreasuryCashierEntries < ActiveRecord::Migration[7.0]
  def change
    change_column :treasury_cashier_entries, :branch, :integer
  end
end
