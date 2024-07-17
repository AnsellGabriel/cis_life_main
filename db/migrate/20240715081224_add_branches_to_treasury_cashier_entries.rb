class AddBranchesToTreasuryCashierEntries < ActiveRecord::Migration[7.0]
  def change
    add_reference :treasury_cashier_entries, :branch, foreign_key: true
    add_column :treasury_cashier_entries, :unuse, :decimal, precision: 15, scale: 2, default: 0
    add_column :treasury_cashier_entries, :vat_exempt, :decimal, precision: 15, scale: 2, default: 0
    add_column :treasury_cashier_entries, :zero_rated, :decimal, precision: 15, scale: 2, default: 0
    # add_column :treasury_cashier_entries, :vatable_amount, :decimal, precision: 15, scale: 2, default: 0
    # change_column :treasury_cashier_entries, :amount, :decimal, default: 0, precision: 15, scale: 2
    # add_column :treasury_cashier_entries, :insurance, :boolean, default: false
    # add_column :treasury_cashier_entries, :discounted, :boolean, default: false

    remove_column :accounting_vouchers, :branch, :integer
    add_reference :accounting_vouchers, :branch, foreign_key: true
  end
end
