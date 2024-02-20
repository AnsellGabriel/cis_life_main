class AddAuditedToAccountingVouchers < ActiveRecord::Migration[7.0]
  def change
    add_column :accounting_vouchers, :audit, :integer, default: 0
    add_column :accounting_vouchers, :audited_by, :integer
  end
end
