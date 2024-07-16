class ChangeAmountColumnInAccountingVouchers < ActiveRecord::Migration[7.0]
  def change
    change_column :accounting_vouchers, :amount, :decimal, precision: 15, scale: 2
  end
end
