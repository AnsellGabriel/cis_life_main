class CreateClaimCoverages < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_coverages do |t|
      t.references :process_claim#, null: false, foreign_key: true
      t.references :coverageable, polymorphic: true, null: false
      t.decimal :amount_benefit, precision: 12, scale: 2
      t.string :coverage_type

      t.timestamps
    end
  end
end
