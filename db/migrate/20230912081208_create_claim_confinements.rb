class CreateClaimConfinements < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_confinements do |t|
      t.references :process_claim#, null: false, foreign_key: true
      t.date :date_admit
      t.date :date_discharge
      t.decimal :terms, precision: 6, scale: 2
      t.decimal :amount, precision: 12, scale: 2

      t.timestamps
    end
  end
end
