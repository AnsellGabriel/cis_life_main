class ChangeColumnForProcessClaims < ActiveRecord::Migration[7.0]
  def change
    remove_column :process_claims, :batch_beneficiary_id
    add_column :process_claims, :claimant_name, :string
  end
end
