class CreateGroupImportTrackers < ActiveRecord::Migration[7.0]
  def change
    create_table :group_import_trackers do |t|
      t.float :progress
      t.references :group_remit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
