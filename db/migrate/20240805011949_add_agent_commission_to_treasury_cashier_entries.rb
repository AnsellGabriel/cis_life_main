class AddAgentCommissionToTreasuryCashierEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :treasury_cashier_entries, :agent_com, :decimal, precision: 10, scale: 2, default: 0
  end
end
