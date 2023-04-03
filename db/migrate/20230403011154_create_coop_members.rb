class CreateCoopMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :coop_members do |t|
      t.references :cooperative, null: false, foreign_key: true
      t.references :coop_branch, null: false, foreign_key: true
      t.string :last_name
      t.string :first_name
      t.string :middle_name
      t.string :suffix
      t.date :birthdate
      t.integer :mobile_number
      t.string :email

      t.timestamps
    end
  end
end
