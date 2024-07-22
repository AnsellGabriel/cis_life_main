class AddColumnToProcessClaims < ActiveRecord::Migration[7.0]
  def change
    add_column :process_claims, :old_code, :string 
    add_column :agents, :full_name, :string
  end
end
