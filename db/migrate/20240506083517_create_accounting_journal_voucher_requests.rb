class CreateAccountingJournalVoucherRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :accounting_journal_voucher_requests do |t|
      t.references :requestable, polymorphic: true, null: false
      t.decimal :amount
      t.integer :status
      t.text :particulars

      t.timestamps
    end
  end
end
