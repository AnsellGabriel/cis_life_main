class CreateClaimCauses < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_causes do |t|
      t.text :acd
      t.text :ucd
      t.text :osccd
      t.text :icd
      t.references :process_claim, null: false, foreign_key: true

      t.timestamps
    end
  end
end
