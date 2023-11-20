class AddAmountToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :amount, :decimal, precision: 15, scale: 2
  end
end
