class AddCoopMemberToProcessClaims < ActiveRecord::Migration[7.0]
  def change
    add_reference :process_claims, :coop_member
  end
end
