class AddColumnToCooperatives < ActiveRecord::Migration[7.0]
  def change
    add_column :cooperatives, :description, :text
    add_column :cooperatives, :registration_number, :string
    add_column :cooperatives, :tin_number, :integer
    add_column :cooperatives, :cooperative_type, :string
    add_column :cooperatives, :acronym, :string
    add_column :cooperatives, :street, :string
  end
end
