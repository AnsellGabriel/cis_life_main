class AddGeoToMember < ActiveRecord::Migration[7.0]
  def change
    change_table :members do |t|
      t.references :geo_region
      t.references :geo_province
      t.references :geo_municipality
      t.references :geo_barangay
    end
    remove_column :members, :region, :string
    remove_column :members, :province, :string
    remove_column :members, :municipality, :string
    remove_column :members, :barangay, :string
  end
end
