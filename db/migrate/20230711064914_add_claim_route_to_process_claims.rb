class AddClaimRouteToProcessClaims < ActiveRecord::Migration[7.0]
  def change
    add_column :process_claims, :claim_route, :integer
  end
end
