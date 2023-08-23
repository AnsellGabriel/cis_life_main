class CreateProcessTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :process_tracks do |t|
      t.string :description
      t.integer :route_id
      t.references :user, null: false, foreign_key: true
      t.references :trackable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
