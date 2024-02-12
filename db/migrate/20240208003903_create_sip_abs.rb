class CreateSipAbs < ActiveRecord::Migration[7.0]
  def change
    create_table :sip_abs do |t|
      t.string :name
      t.integer :min_age
      t.integer :max_age
      t.integer :insured_type
      t.integer :exit_age

      t.timestamps
    end
  end
end
