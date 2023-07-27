class CreateDeniedDependents < ActiveRecord::Migration[7.0]
  def change
    create_table :denied_dependents do |t|
      t.string :name
      t.string :age
      t.string :reason
      t.boolean :beneficiary
      t.boolean :dependent
      t.references :group_remit, null: false, foreign_key: true
      t.references :batch, null: false, foreign_key: true

      t.timestamps
    end
  end
end
