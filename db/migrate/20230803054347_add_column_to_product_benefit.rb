class AddColumnToProductBenefit < ActiveRecord::Migration[7.0]
  def change
    add_column :product_benefits, :main, :boolean
    add_column :agreements, :claims_fund_amount, :decimal, precision: 10, scale: 2
    add_reference :cooperatives, :coop_type
    change_table :coop_branches do |t|
      t.references :geo_region
      t.references :geo_province
      t.references :geo_municipality
      t.references :geo_barangay
    end
  end
end
