class AddPayoutTypeToCheckVoucherRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :check_voucher_requests, :payout_type, :integer
  end
end
