class AddColumnsToTreasuryAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :treasury_accounts, :old_code, :string
    add_column :treasury_accounts, :parent_code, :string
    add_column :treasury_accounts, :children, :integer, default: 0
  end
end
