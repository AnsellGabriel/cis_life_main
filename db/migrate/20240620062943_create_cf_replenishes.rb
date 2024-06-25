class CreateCfReplenishes < ActiveRecord::Migration[7.0]
  def change
    create_table :cf_replenishes do |t|
      t.references :cf_account#, null: false, foreign_key: true
      t.references :user#, null: false, foreign_key: true
      t.date :transaction_date
      t.decimal :amount, precision: 18, scale: 2
      t.string :description
      t.integer :status

      t.timestamps
    end
  end
end
