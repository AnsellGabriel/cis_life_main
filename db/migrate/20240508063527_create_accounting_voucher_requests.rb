class CreateAccountingVoucherRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :voucher_requests do |t|
      t.references :requestable, polymorphic: true, null: false
      t.decimal :amount
      t.integer :status
      t.string :requester
      t.text :particulars
      t.integer :payment_type
      t.integer :request_type
      t.references :account, foreign_key: {to_table: :treasury_accounts}

      t.timestamps
    end
  end
end
