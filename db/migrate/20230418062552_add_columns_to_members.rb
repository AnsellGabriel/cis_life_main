class AddColumnsToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :region, :string
    add_column :members, :province, :string
    add_column :members, :municipality, :string
    add_column :members, :barangay, :string
    add_column :members, :street, :string
  end
end