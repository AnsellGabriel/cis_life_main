class CreateTransmittals < ActiveRecord::Migration[7.0]
  def change
    create_table :transmittals do |t|
      t.string :code
      t.string :description
      t.integer :transmittal_type

      t.timestamps
    end
  end
end
