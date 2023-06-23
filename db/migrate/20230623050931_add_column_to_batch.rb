class AddColumnToBatch < ActiveRecord::Migration[7.0]
  def change
    add_column :batches, :valid_health_dec, :boolean, default: false
  end
end
