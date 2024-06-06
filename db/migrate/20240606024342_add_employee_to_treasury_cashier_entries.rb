class AddEmployeeToTreasuryCashierEntries < ActiveRecord::Migration[7.0]
  def change
    add_reference :treasury_cashier_entries, :employee, foreign_key: true
  end
end
