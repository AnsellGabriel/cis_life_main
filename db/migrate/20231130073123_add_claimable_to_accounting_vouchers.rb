class AddClaimableToAccountingVouchers < ActiveRecord::Migration[7.0]
  def change
    add_column :accounting_vouchers, :claimable, :boolean, default: false
  end
end
