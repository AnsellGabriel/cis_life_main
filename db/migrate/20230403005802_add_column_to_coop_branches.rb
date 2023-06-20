class AddColumnToCoopBranches < ActiveRecord::Migration[7.0]
  def change
    add_column :coop_branches, :description, :text
    add_column :coop_branches, :street, :string
  end
end
