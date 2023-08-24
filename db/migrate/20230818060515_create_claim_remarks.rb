class CreateClaimRemarks < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_remarks do |t|
      t.references :process_claim, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status
      t.text :remark

      t.timestamps
    end
  end
end
