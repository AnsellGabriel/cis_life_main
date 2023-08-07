class AddBatchRemitIdToGroupRemit < ActiveRecord::Migration[7.0]
  def change
    add_column :group_remits, :batch_remit_id, :integer
  end
end
