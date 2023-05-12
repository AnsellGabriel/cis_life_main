class CreateAgents < ActiveRecord::Migration[7.0]
  def change
    create_table :agents do |t|
      t.string :last_name
      t.string :first_name
      t.string :middle_name
      t.date :birthdate
      t.string :mobile_number

      t.timestamps
    end
  end
end
