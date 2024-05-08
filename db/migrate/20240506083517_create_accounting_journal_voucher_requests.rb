class CreateAccountingJournalVoucherRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :journal_voucher_requests do |t|
      t.references :requestable, polymorphic: true, null: false
      t.decimal :amount
      t.integer :status
      t.integer :request_type
      t.text :particulars

      t.timestamps
    end
  end
end
