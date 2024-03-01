class AddAgentToGroupProposal < ActiveRecord::Migration[7.0]
  def change
    add_reference :group_proposals, :agent#, null: false, foreign_key: true
    add_column :group_proposals, :anniversary_type, :string
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
