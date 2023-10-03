class CreatePlanUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :plan_units do |t|
      t.belongs_to :plan#, null: false, foreign_key: true
      t.string :name
      t.decimal :total_prem, precision: 10, scale: 2

      t.timestamps
    end
  end
end
