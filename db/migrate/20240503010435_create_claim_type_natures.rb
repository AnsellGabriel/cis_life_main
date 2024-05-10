class CreateClaimTypeNatures < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_type_natures do |t|
      t.references :claim_type, null: false, foreign_key: true
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
