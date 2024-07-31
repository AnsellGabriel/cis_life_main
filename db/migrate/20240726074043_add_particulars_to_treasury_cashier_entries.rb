class AddParticularsToTreasuryCashierEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :treasury_cashier_entries, :particulars, :text
    remove_reference :treasury_cashier_entries, :treasury_payment_type, index: true, foreign_key: true
  end
end
