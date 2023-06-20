class RenameSubmittedToStatus < ActiveRecord::Migration[7.0]
  def change
    rename_column :group_remits, :submitted, :status
    change_column :group_remits, :status, :integer, default: 0
  end
end
