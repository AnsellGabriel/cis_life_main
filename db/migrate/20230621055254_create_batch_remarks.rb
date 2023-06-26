class CreateBatchRemarks < ActiveRecord::Migration[7.0]
  def change
    create_table :batch_remarks do |t|
      t.references :batch, null: false, foreign_key: true
      t.text :remark
      t.integer :status
      t.references :user, polymorphic: true, null: false

      t.timestamps
    end
  end
end
