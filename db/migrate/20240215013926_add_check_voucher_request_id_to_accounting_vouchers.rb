class AddCheckVoucherRequestIdToAccountingVouchers < ActiveRecord::Migration[7.0]
  def change
    add_column :accounting_vouchers, :check_voucher_request_id, :integer
  end
end
