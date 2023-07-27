class CreateMemberImportTrackers < ActiveRecord::Migration[7.0]
  def change
    create_table :member_import_trackers do |t|
      t.float :progress
      t.references :coop_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
