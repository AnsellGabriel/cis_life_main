class CreateGeoMunicipalities < ActiveRecord::Migration[7.0]
  def change
    create_table :geo_municipalities do |t|
      t.string :name
      t.references :geo_region#, null: false, foreign_key: true
      t.references :geo_province#, null: false, foreign_key: true

      t.timestamps
    end
  end
end
