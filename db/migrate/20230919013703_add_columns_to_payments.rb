class AddColumnsToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :or_number, :integer
    add_column :payments, :or_date, :date
    add_column :payments, :status, :integer, default: 0
  end
end
