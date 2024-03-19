class AddBranchToTreasuryCashierEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :treasury_cashier_entries, :branch, :string
  end
end
