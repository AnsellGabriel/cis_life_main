class CreateCoopBranches < ActiveRecord::Migration[7.0]
  def change
    create_table :coop_branches do |t|
      t.string :name
      t.text :description
      t.string :region
      t.string :province
      t.string :municipality
      t.string :barangay
      t.string :street
      t.string :contact_details
      t.references :cooperative, null: false, foreign_key: true

      t.timestamps
    end
  end
end
