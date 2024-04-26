class AddBranchesToAccountingVouchers < ActiveRecord::Migration[7.0]
  def change
    add_column :accounting_vouchers, :branch, :integer
  end
end
