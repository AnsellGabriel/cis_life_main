class AddBranchToEmployees < ActiveRecord::Migration[7.0]
  def change
    add_column :employees, :branch, :integer
  end
end
