class CreateAdjustedCoverages < ActiveRecord::Migration[7.0]
  def change
    create_table :adjusted_coverages do |t|
      t.references :coverageable, polymorphic: true, null: false#, foreign_key: true
      t.decimal :adjusted_coverage, precision: 10, scale: 2
      t.decimal :adjusted_premium, precision: 10, scale: 2
      t.decimal :substandard_rate, precision: 10, scale: 2
      t.decimal :underpayment, precision: 10, scale: 2
      t.decimal :total_rate, precision: 10, scale: 2
      t.integer :status

      t.timestamps
    end
  end
end
