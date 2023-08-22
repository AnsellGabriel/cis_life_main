class CreateClaimBenefits < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_benefits do |t|
      t.references :process_claim#, null: false, foreign_key: true
      t.references :benefit#, null: false, foreign_key: true
      t.decimal :amount, precision: 12, scale: 2
      t.string :status

      t.timestamps
    end
  end
end
