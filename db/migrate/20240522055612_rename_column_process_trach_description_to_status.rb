class RenameColumnProcessTrachDescriptionToStatus < ActiveRecord::Migration[7.0]
  def change
    rename_column :process_tracks, :description, :status
    change_column :process_tracks, :status, :integer
  end
end
