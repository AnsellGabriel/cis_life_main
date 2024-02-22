class AddPostDateToVouchers < ActiveRecord::Migration[7.0]
  def change
    add_column :accounting_vouchers, :post_date, :date
    add_column :accounting_vouchers, :accountant_id, :integer
  end
end
