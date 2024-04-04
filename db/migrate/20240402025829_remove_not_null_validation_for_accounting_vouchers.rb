class RemoveNotNullValidationForAccountingVouchers < ActiveRecord::Migration[7.0]
  def change
    change_column_null :accounting_vouchers, :treasury_account_id, true
  end
end
