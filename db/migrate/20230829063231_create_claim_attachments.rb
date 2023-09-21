class CreateClaimAttachments < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_attachments do |t|
      t.references :process_claim, null: false, foreign_key: true
      t.references :claim_type_document, null: false, foreign_key: true

      t.timestamps
    end
  end
end
