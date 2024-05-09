class ChangeColumnTypeForTreasuryAccounts < ActiveRecord::Migration[7.0]
  def change
    change_column :treasury_accounts, :account_number, :string
  end
end
