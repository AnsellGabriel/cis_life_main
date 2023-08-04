class AddColumnToProductBenefit < ActiveRecord::Migration[7.0]
  def change
    add_column :product_benefits, :main, :boolean
    change_table :coop_branches do |t|
      t.references :geo_region
      t.references :geo_province
      t.references :geo_municipality
      t.references :geo_barangay
    end
  end
end
