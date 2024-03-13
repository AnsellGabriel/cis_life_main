class ChangeOrNoTypeOfTreasuryCashierEntries < ActiveRecord::Migration[7.0]
  def change
    change_column :treasury_cashier_entries, :or_no, :string
  end
end
