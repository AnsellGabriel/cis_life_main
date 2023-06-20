class AddBenefitToProductBenefits < ActiveRecord::Migration[7.0]
  def change
    add_reference :product_benefits, :benefit, null: false, foreign_key: true
  end
end
