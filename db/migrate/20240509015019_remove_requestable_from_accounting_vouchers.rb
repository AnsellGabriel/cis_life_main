class RemoveRequestableFromAccountingVouchers < ActiveRecord::Migration[7.0]
  def change
    remove_column :accounting_vouchers, :requestable_id
    remove_column :accounting_vouchers, :requestable_type
    add_reference :accounting_vouchers, :request, foreign_key: {to_table: :voucher_requests}
  end
end
