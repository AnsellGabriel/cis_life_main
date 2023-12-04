class CreateClaimPayments < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_payments do |t|
      t.string :beneficiary
      t.decimal :amount, precision: 15, scale: 2
      t.references :process_claim, null: false, foreign_key: true

      t.timestamps
    end
  end
end
