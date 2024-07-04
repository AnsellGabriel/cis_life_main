class AddColumnsToCoopBanks < ActiveRecord::Migration[7.0]
  def change
    add_column :coop_banks, :name, :string
    add_column :coop_banks, :branch, :string
    add_column :coop_banks, :account_number, :string
    remove_column :coop_banks, :treasury_account_id, :bigint
  end
end
