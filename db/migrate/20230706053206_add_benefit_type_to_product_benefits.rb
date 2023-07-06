class AddBenefitTypeToProductBenefits < ActiveRecord::Migration[7.0]
  def change
    add_column :product_benefits, :benefit_type, :string
  end
end
