class AddBankIdToCheckVoucherRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :check_voucher_requests, :bank_id, :integer
  end
end
