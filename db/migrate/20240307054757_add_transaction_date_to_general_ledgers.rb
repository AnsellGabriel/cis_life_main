class AddTransactionDateToGeneralLedgers < ActiveRecord::Migration[7.0]
  def change
    add_column :general_ledgers, :transaction_date, :date
  end
end
