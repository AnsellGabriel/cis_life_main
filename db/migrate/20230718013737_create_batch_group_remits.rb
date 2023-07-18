class CreateBatchGroupRemits < ActiveRecord::Migration[7.0]
  def change
    create_table :batch_group_remits do |t|
      t.references :batch, null: false, foreign_key: true
      t.references :group_remit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
