class AddEmailAndNumberToCooperatives < ActiveRecord::Migration[7.0]
  def change
    add_column :cooperatives, :email, :string
    add_column :cooperatives, :contact_number, :string
  end
end
