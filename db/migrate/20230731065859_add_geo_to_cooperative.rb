class AddGeoToCooperative < ActiveRecord::Migration[7.0]
  def change
     change_table :cooperatives do |t|
      t.references :geo_region
      t.references :geo_province
      t.references :geo_municipality
      t.references :geo_barangay
    end
    remove_column :cooperatives, :region, :string
    remove_column :cooperatives, :province, :string
    remove_column :cooperatives, :municipality, :string
    remove_column :cooperatives, :barangay, :string
  end
end
