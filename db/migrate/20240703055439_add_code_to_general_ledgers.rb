class AddCodeToGeneralLedgers < ActiveRecord::Migration[7.0]
  def change
    add_column :general_ledgers, :code, :string
    add_column :treasury_sub_accounts, :code, :string
  end
end
