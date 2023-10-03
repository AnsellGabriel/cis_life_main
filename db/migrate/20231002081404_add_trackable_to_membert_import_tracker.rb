class AddTrackableToMembertImportTracker < ActiveRecord::Migration[7.0]
  def change
    add_reference :member_import_trackers, :trackable, polymorphic: true, null: false
    remove_column :member_import_trackers, :coop_user_id, :integer
  end
end
