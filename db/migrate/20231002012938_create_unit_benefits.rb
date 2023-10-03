class CreateUnitBenefits < ActiveRecord::Migration[7.0]
  def change
    create_table :unit_benefits do |t|
      t.references :plan_unit#, null: false, foreign_key: true
      t.references :benefit#, null: false, foreign_key: true
      t.decimal :coverage_amount, precision: 10, scale: 2

      t.timestamps
    end
  end
end
