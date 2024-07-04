class CreateAccountingAccountBeginningBalances < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts_beginning_balances do |t|
      t.references :account, null: false, foreign_key: {to_table: :treasury_accounts}
      t.decimal :debit, precision: 15, scale: 2
      t.decimal :credit, precision: 15, scale: 2
      t.integer :year

      t.timestamps
    end
  end
end
