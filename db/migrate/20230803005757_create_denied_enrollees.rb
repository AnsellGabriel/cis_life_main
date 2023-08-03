class CreateDeniedEnrollees < ActiveRecord::Migration[7.0]
  def change
    create_table :denied_enrollees do |t|
      t.string :name
      t.string :reason
      t.references :cooperative, null: false, foreign_key: true

      t.timestamps
    end
  end
end
