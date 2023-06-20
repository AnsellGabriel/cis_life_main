class RemoveCooperativeFromGroupRemits < ActiveRecord::Migration[7.0]
  def change
    remove_column :group_remits, :cooperative_id
  end
end
