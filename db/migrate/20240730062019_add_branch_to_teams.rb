class AddBranchToTeams < ActiveRecord::Migration[7.0]
  def change
    add_reference :teams, :branch, foreign_key: true, null: true
  end
end
