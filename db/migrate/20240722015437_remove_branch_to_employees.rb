class RemoveBranchToEmployees < ActiveRecord::Migration[7.0]
  def change
    # remove_column :employees, :branch, :integer
    # add_reference :employees, :branch, foreign_key: true
  end
end
