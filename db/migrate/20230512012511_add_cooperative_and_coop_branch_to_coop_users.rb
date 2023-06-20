class AddCooperativeAndCoopBranchToCoopUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :coop_users, :cooperative, null: false, foreign_key: true
    add_reference :coop_users, :coop_branch, null: false, foreign_key: true
  end
end
