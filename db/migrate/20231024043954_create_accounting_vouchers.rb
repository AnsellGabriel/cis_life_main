class CreateAccountingVouchers < ActiveRecord::Migration[7.0]
  def change
    create_table :accounting_vouchers do |t|
      t.date :date_voucher
      t.integer :voucher
      t.references :payable, polymorphic: true, null: false
      t.references :treasury_account, foreign_key: true
      t.decimal :amount, precision: 15, scale: 2
      t.text :particulars
      t.string :type

      t.timestamps
    end
  end
end
