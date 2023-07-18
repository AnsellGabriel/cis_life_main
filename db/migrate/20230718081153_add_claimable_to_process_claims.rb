class AddClaimableToProcessClaims < ActiveRecord::Migration[7.0]
  def change
    add_reference :process_claims, :claimable, polymorphic: true, null: false
  end
end
