class AddRetrieveToProcessClaims < ActiveRecord::Migration[7.0]
  def change
    add_reference :process_claims, :claim_retrieval
    add_column :process_claims, :micro, :boolean 
    add_column :cf_replenishes, :orno, :string 
    add_column :cf_replenishes, :ordate, :date 
    add_column :plans, :micro, :boolean
    add_column :cf_accounts, :code, :string 
    add_column :cf_accounts, :id_code, :integer
  end
end
