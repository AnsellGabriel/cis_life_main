class AddCertifiedByToAccountingVouchers < ActiveRecord::Migration[7.0]
  def change
    add_column :accounting_vouchers, :certified_by, :integer
  end
end
