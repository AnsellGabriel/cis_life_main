class AddMinimumParticipationToProposals < ActiveRecord::Migration[7.0]
  def change
    add_column :proposals, :minimum_participation, :integer
  end
end
