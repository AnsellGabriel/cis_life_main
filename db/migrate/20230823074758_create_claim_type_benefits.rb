class CreateClaimTypeBenefits < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_type_benefits do |t|
      t.references :claim_type#, null: false, foreign_key: true
      t.references :benefit#, null: false, foreign_key: true

      t.timestamps
    end
  end
end
