class AddRequestableToAccountingVouchers < ActiveRecord::Migration[7.0]
  def change
    add_reference :accounting_vouchers, :requestable, polymorphic: true
    # remove_column :accounting_vouchers, :check_voucher_request_id
  end
end
