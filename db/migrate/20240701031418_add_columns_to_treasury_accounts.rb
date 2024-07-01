class AddColumnsToTreasuryAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :treasury_accounts, :old_code, :string
    add_column :treasury_accounts, :parent_code, :string
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
