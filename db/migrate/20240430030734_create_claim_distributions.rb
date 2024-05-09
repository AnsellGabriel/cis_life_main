class CreateClaimDistributions < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_distributions do |t|
      t.references :process_claim#, null: false, foreign_key: true
      t.string :name
      t.string :relationship
      t.decimal :amount, precision: 10, scale: 2

      t.timestamps
    end
  end
end
