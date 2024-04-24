class ModifyCoopBanks < ActiveRecord::Migration[7.0]
  def change
    add_column :treasury_accounts, :account_category, :integer
    add_column :treasury_accounts, :account_number, :integer
    remove_column :coop_banks, :account_name, :string
    remove_column :coop_banks, :account_number, :string
    remove_column :coop_banks, :address, :string
    add_reference :coop_banks, :treasury_account, foreign_key: true
  end
end
