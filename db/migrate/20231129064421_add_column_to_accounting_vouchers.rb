class AddColumnToAccountingVouchers < ActiveRecord::Migration[7.0]
  def change
    # add_reference :accounting_vouchers, :check_voucher_request, foreign_key: true
    add_reference :accounting_vouchers, :claim_request_for_payment, foreign_key: true
  end
end
