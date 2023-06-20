class AddProposalNoToProposals < ActiveRecord::Migration[7.0]
  def change
    add_column :proposals, :proposal_no, :string
  end
end
