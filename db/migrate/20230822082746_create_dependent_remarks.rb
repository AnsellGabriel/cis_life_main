class CreateDependentRemarks < ActiveRecord::Migration[7.0]
  def change
    create_table :dependent_remarks do |t|
      t.references :batch_dependent, null: false, foreign_key: true
      t.text :remark
      t.integer :status

      t.timestamps
    end
  end
end
