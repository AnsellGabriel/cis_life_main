class CreateCooperatives < ActiveRecord::Migration[7.0]
  def change
    create_table :cooperatives do |t|
      t.string :name
      t.text :description
      t.integer :tin_number
      t.string :region
      t.string :province
      t.string :municipality
      t.string :barangay
      t.string :street
      t.string :contact_details
      t.string :registration_number
      t.string :cooperative_type
      t.string :acronym
      t.string :email
      t.string :contact_number
      
      t.timestamps
    end
  end
end
