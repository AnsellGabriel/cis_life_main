class CreateCoopUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :coop_users do |t|
      t.string :last_name
      t.string :first_name
      t.string :middle_name
      t.date :birthdate
      t.string :mobile_number
      t.string :designation
      t.references :cooperative, null: false, foreign_key: true
      t.references :coop_branch, null: false, foreign_key: true

      t.timestamps
    end
  end
end
