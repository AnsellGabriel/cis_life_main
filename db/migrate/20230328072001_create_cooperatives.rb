class CreateCooperatives < ActiveRecord::Migration[7.0]
  def change
    create_table :cooperatives do |t|
      t.string :name
      t.string :region
      t.string :province
      t.string :municipality
      t.string :barangay
      t.string :contact_details

      t.timestamps
    end
  end
end
