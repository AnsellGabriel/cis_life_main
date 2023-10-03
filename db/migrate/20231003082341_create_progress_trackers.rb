class CreateProgressTrackers < ActiveRecord::Migration[7.0]
  def change
    create_table :progress_trackers do |t|
      t.float :progress
      t.references :trackable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
