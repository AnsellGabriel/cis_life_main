class CreateAccountingCheckVouchers < ActiveRecord::Migration[7.0]
  def change
    create_table :accounting_check_vouchers do |t|
      t.date :date_voucher
      t.string :voucher
      t.references :payable, polymorphic: true, null: false
      t.decimal :amount, precision: 15, scale: 2
      t.text :particulars

      t.timestamps
    end
  end
end
