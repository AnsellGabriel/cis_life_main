class CreateProcessRemarks < ActiveRecord::Migration[7.0]
  def change
    create_table :process_remarks do |t|
      t.references :process_coverage#, null: false, foreign_key: true
      t.text :remark
      t.string :status
      t.references :user, polymorphic: true#, null: false

      t.timestamps
    end
  end
end
