class CreateClaimTypeAgreements < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_type_agreements do |t|
      t.references :agreement#, null: false, foreign_key: true
      t.references :claim_type#, null: false, foreign_key: true

      t.timestamps
    end
  end
end
