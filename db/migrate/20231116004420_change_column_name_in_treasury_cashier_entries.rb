class ChangeColumnNameInTreasuryCashierEntries < ActiveRecord::Migration[7.0]
  def change
    rename_column :treasury_cashier_entries, :payment, :payment_type
  end
end
