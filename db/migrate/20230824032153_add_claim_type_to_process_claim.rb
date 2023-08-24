class AddClaimTypeToProcessClaim < ActiveRecord::Migration[7.0]
  def change
    add_reference :process_claims, :claim_type, foreign_key: false
  end
end
