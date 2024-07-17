class AddAgentToCashierEntries < ActiveRecord::Migration[7.0]
  def change
    add_reference :treasury_cashier_entries, :agent, foreign_key: true
    add_column :agents, :code, :string
    add_column :treasury_payment_types, :code, :string
  end
end
