class CreateCooperatives < ActiveRecord::Migration[7.0]
  def change
    create_table :cooperatives do |t|
      t.references :coop_type#, null: false, foreign_key: true
      t.references :geo_region#, null: false, foreign_key: true
      t.references :geo_province#, null: false, foreign_key: true
      t.references :geo_municipality#, null: false, foreign_key: true
      t.references :geo_barangay#, null: false, foreign_key: true
      t.string :street
      t.string :name
      t.text :description
      t.string :registration_no
      t.string :tin
      t.string :acronym
      t.string :contact_no
      t.string :email

      t.timestamps
    end
  end
end
