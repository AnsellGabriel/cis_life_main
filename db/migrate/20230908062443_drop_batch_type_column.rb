class DropBatchTypeColumn < ActiveRecord::Migration[7.0]
  def change
    remove_column :batch_remarks, :batch_type
  end
end
