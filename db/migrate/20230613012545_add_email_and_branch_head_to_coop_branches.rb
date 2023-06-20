class AddEmailAndBranchHeadToCoopBranches < ActiveRecord::Migration[7.0]
  def change
    add_column :coop_branches, :email, :string
    add_column :coop_branches, :branch_head, :string
  end
end
