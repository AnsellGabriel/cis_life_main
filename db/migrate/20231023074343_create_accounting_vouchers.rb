class CreateAccountingVouchers < ActiveRecord::Migration[7.0]
  def change
    create_table :accounting_vouchers do |t|
      t.date :date_voucher
      t.integer :voucher
      t.references :payable, polymorphic: true, null: false
      t.references :treasury_account, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.text :particulars

      t.timestamps
    end
  end
end
