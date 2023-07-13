class AddStatusToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :amount, :decimal, precision: 10, scale: 2
    add_column :payments, :status, :integer
  end
end
