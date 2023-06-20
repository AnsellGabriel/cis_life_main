class CreateProductBenefits < ActiveRecord::Migration[7.0]
  def change
    create_table :product_benefits do |t|
      t.decimal :coverage_amount, precision: 10, scale: 2
      t.decimal :premium, precision: 10, scale: 2
      t.references :agreement_benefit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
