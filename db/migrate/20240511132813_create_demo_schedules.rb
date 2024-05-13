class CreateDemoSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :demo_schedules do |t|
      t.string :cooperative
      t.string :name
      t.string :contact_no
      t.string :email
      t.date :demo_date
      t.integer :time_slot
      t.text :remarks
      t.integer :satus
      t.integer :method

      t.timestamps
    end
  end
end
