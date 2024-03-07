class AddVatToTreasuryCashierEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :treasury_cashier_entries, :vat, :decimal, precision: 15, scale: 2, default: 0.0
    add_column :treasury_cashier_entries, :discount, :decimal, precision: 15, scale: 2, default: 0.0
    add_column :treasury_cashier_entries, :net_amount, :decimal, precision: 15, scale: 2, default: 0.0
    add_column :treasury_cashier_entries, :withholding_tax, :decimal, precision: 15, scale: 2, default: 0.0
    add_column :treasury_cashier_entries, :vatable, :boolean, default: false
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
