class CreateAccountingDebitAdviceJournals < ActiveRecord::Migration[7.0]
  def change
    create_table :accounting_debit_advice_journals do |t|
      t.belongs_to :debit_advice, null: false, foreign_key: { to_table: :accounting_vouchers }
      t.belongs_to :journal_voucher, null: false, foreign_key: { to_table: :accounting_vouchers }

      t.timestamps
    end
  end
end
