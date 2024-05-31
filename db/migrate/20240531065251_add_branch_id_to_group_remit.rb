class AddBranchIdToGroupRemit < ActiveRecord::Migration[7.0]
  def change
    add_reference :group_remits, :coop_branch, foreign_key: true
  end
end
