class AddPaymentTypeToCheckVoucherRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :check_voucher_requests, :payment_type, :integer
  end
end
