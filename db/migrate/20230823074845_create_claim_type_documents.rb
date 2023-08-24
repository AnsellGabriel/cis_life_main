class CreateClaimTypeDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_type_documents do |t|
      t.references :claim_type#, null: false, foreign_key: true
      t.references :document#, null: false, foreign_key: true
      t.boolean :required

      t.timestamps
    end
  end
end
