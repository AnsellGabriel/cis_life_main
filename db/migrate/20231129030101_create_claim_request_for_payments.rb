class CreateClaimRequestForPayments < ActiveRecord::Migration[7.0]
  def change
    create_table :claim_request_for_payments do |t|
      t.references :process_claim, null: false, foreign_key: true
      t.decimal :amount, precision: 15, scale: 2
      t.integer :status, default: 0
      t.string :analyst

      t.timestamps
    end
  end
end
