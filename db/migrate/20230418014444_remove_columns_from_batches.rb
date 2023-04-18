class RemoveColumnsFromBatches < ActiveRecord::Migration[7.0]
  def change
    remove_column :batches, :coop_member_id, :integer
    remove_column :batches, :group_remit_id, :integer
  end
end
