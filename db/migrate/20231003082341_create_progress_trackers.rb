class CreateProgressTrackers < ActiveRecord::Migration[7.0]
  def change
    create_table :progress_trackers do |t|
      t.float :progress, precision: 5, scale: 2, default: 0.0
      t.references :trackable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
