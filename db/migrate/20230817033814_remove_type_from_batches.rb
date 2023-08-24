class RemoveTypeFromBatches < ActiveRecord::Migration[7.0]
  def change
    remove_column :batches, :type
  end
end
