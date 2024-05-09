class AddEntryTypeToAuthorityLevel < ActiveRecord::Migration[7.0]
  def change
    add_column :authority_levels, :entry_type, :integer
    add_column :claim_type_documents, :name, :string
    remove_reference :claim_type_documents, :document
    drop_table :documents
  end
end
