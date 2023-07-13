class AddRelationshipToProcessClaims < ActiveRecord::Migration[7.0]
  def change
    add_column :process_claims, :relationship, :string
  end
end
