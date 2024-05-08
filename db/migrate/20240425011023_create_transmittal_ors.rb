class CreateTransmittalOrs < ActiveRecord::Migration[7.0]
  def change
    create_table :transmittal_ors do |t|
      t.references :transmittal#, null: false, foreign_key: true
      t.references :transmittable, polymorphic: true#, null: false

      t.timestamps
    end
  end
end
