class CreateClaimReinsurances < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_reinsurances do |t|
      t.references :process_claim#, null: false, foreign_key: true
      t.integer :status
      
      t.timestamps
    end
  end
end
