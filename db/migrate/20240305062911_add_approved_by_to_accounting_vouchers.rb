class AddApprovedByToAccountingVouchers < ActiveRecord::Migration[7.0]
  def change
    add_column :accounting_vouchers, :approved_by, :integer
  end
end
