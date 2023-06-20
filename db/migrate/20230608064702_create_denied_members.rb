class CreateDeniedMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :denied_members do |t|
      t.string :name
      t.integer :age
      t.string :reason
      t.references :group_remit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
