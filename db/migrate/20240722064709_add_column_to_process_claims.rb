class AddColumnToProcessClaims < ActiveRecord::Migration[7.0]
  def change
    add_column :process_claims, :old_code, :string 
    add_column :agents, :full_name, :string
    add_reference :process_claims, :user
    add_reference :process_claims, :insurable, polymorphic: true, null: false
    remove_reference :process_claims, :coop_member
  end
end
