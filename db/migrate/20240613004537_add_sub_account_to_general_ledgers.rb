class AddSubAccountToGeneralLedgers < ActiveRecord::Migration[7.0]
  def change
    add_reference :general_ledgers, :sub_account, foreign_key: { to_table: :treasury_sub_accounts }
  end
end
