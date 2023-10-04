class DropMemberImportTrackers < ActiveRecord::Migration[7.0]
  def change
    drop_table :member_import_trackers
    drop_table :group_import_trackers
  end
end
