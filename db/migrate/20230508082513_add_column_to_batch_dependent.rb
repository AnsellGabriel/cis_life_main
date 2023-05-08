class AddColumnToBatchDependent < ActiveRecord::Migration[7.0]
  def change
    add_column :batch_dependents, :coop_sf_amount, :decimal
    add_column :batch_dependents, :agent_sf_amount, :decimal
  end
end
