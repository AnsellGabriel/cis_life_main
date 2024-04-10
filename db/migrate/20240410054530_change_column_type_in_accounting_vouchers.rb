class ChangeColumnTypeInAccountingVouchers < ActiveRecord::Migration[7.0]
  def change
    change_column :accounting_vouchers, :voucher, :string
  end
end
