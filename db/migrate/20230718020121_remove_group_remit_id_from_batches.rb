class RemoveGroupRemitIdFromBatches < ActiveRecord::Migration[7.0]
  def change
    remove_column :batches, :group_remit_id
  end
end
