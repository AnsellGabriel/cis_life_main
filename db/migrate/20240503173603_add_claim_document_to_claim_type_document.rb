class AddClaimDocumentToClaimTypeDocument < ActiveRecord::Migration[7.0]
  def change
    add_reference :claim_type_documents, :claim_document
    remove_column :process_claims, :nature_of_claim, :integer
    add_reference :process_claims, :claim_type_nature
  end
end
