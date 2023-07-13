class CreateClaimDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_documents do |t|
      t.references :process_claim, null: false, foreign_key: true
      t.string :document
      t.integer :document_type

      t.timestamps
    end
  end
end
