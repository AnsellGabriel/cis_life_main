class AddColumnsToProductBenefits < ActiveRecord::Migration[7.0]
  def change
    add_column :product_benefits, :duration, :integer, null: true
    add_column :product_benefits, :residency_floor, :integer, null: true
    add_column :product_benefits, :residency_ceiling, :integer, null: true
  end
end
