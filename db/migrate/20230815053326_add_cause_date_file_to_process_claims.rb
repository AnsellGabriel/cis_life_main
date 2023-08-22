class AddCauseDateFileToProcessClaims < ActiveRecord::Migration[7.0]
  def change
    add_reference :process_claims, :cause, foreign_key: false
    add_column :process_claims, :date_file, :date 
    add_column :process_claims, :claim_filed, :boolean 
    add_column :process_claims, :processing, :boolean 
    add_column :process_claims, :approval, :boolean 
    add_column :process_claims, :payment, :boolean 
    
  end
end
