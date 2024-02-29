class CreateProcessClaims < ActiveRecord::Migration[7.0]
  def change
    create_table :process_claims do |t|
      t.references :cooperative#, null: false, foreign_key: true
      t.references :agreement#, null: false, foreign_key: true
      t.references :batch#, null: false, foreign_key: true
      t.date :date_incident
      t.string :entry_type

      t.timestamps
    end
  end
end
