class AddEmployeeToAccountingVouchers < ActiveRecord::Migration[7.0]
  def change
    add_reference :accounting_vouchers, :employee, foreign_key: true
    remove_column :accounting_vouchers, :accountant_id, :bigint
  end
end
