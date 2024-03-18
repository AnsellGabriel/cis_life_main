class AddPaymentTypeToTreasuryCashierEntries < ActiveRecord::Migration[7.0]
  def change
    remove_column :treasury_cashier_entries, :payment_type, :integer
    add_reference :treasury_cashier_entries, :treasury_payment_type, null: false, foreign_key: true
  end
end
