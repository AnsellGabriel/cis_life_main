class CreateDependentHealthDecs < ActiveRecord::Migration[7.0]
  def change
    create_table :dependent_health_decs do |t|
      t.references :batch_dependent, null: false, foreign_key: true
      t.text :answer
      t.references :answerable, polymorphic: true, null: false
      t.timestamps
    end
  end
end
