class CreateProcessCoverages < ActiveRecord::Migration[7.0]
  def change
    create_table :process_coverages do |t|
      t.references :group_remit#, null: false, foreign_key: true
      t.references :agent#, null: false, foreign_key: true
      t.date :effectivity
      t.date :expiry
      t.string :status
      t.integer :approved_count
      t.decimal :approved_total_coverage, precision: 20, scale: 4
      t.decimal :approved_total_prem, precision: 20, scale: 4
      t.integer :denied_count
      t.decimal :denied_total_coverage, precision: 20, scale: 4
      t.decimal :denied_total_prem, precision: 20, scale: 4

      t.timestamps
    end
  end
end
