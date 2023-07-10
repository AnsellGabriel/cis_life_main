class AddColumnsToProcessClaims < ActiveRecord::Migration[7.0]
  def change
    add_column :process_claims, :claimant_email, :string
    add_column :process_claims, :claimant_contact_no, :string
    add_column :process_claims, :nature_of_claim, :integer
  end
end
