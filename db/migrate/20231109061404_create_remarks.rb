class CreateRemarks < ActiveRecord::Migration[7.0]
  def change
    create_table :remarks do |t|
      t.text :remark
      t.references :remarkable, polymorphic: true#, null: false
      t.references :user, null: false

      t.timestamps
    end
  end
end
