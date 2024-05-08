class CreateAccountingDebitAdviceReceipts < ActiveRecord::Migration[7.0]
  def change
    create_table :debit_advice_receipts do |t|
      t.string :receipt
      t.references :debit_advice
      t.timestamps
    end
  end
end
