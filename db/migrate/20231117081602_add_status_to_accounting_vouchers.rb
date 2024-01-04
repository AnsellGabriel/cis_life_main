class AddStatusToAccountingVouchers < ActiveRecord::Migration[7.0]
  def change
    add_column :accounting_vouchers, :status, :integer, default: 0
  end
end
