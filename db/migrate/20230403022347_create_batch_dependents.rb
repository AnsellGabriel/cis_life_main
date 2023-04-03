class CreateBatchDependents < ActiveRecord::Migration[7.0]
  def change
    create_table :batch_dependents do |t|
      t.references :batch, null: false, foreign_key: true
      t.references :coop_dependent, null: false, foreign_key: true
      t.float :premium
      t.references :agreement_benefit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
