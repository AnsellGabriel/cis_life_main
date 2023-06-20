class CreateProposals < ActiveRecord::Migration[7.0]
  def change
    create_table :proposals do |t|
      t.references :cooperative, null: false, foreign_key: true
      t.integer :ave_age
      t.decimal :total_premium, precision: 10, scale: 2
      t.decimal :coop_sf, precision: 10, scale: 2
      t.decimal :agent_sf, precision: 10, scale: 2

      t.timestamps
    end
  end
end
