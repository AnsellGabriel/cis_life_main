class CreateClaimCoverageReinsurances < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_coverage_reinsurances do |t|
      t.references :claim_reinsurance#, null: false, foreign_key: true
      t.references :claim_coverage#, null: false, foreign_key: true
      t.references :reinsurer#, null: false, foreign_key: true
      t.decimal :amount, precision: 18, scale: 2
      t.decimal :ri_reported, precision: 18, scale: 2

      t.timestamps
    end
  end
end
