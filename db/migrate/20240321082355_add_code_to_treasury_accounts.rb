class AddCodeToTreasuryAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :treasury_accounts, :code, :string
  end
end
