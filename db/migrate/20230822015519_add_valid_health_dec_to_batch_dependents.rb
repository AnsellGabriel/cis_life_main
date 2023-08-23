class AddValidHealthDecToBatchDependents < ActiveRecord::Migration[7.0]
  def change
    add_column :batch_dependents, :valid_health_dec, :boolean, default: false
  end
end
