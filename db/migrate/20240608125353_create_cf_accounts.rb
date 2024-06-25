class CreateCfAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :cf_accounts do |t|
      t.references :cooperative#, null: false, foreign_key: true
      t.decimal :amount, precision: 18, scale: 2
      t.decimal :amount_limit, precision: 18, scale: 2
      t.integer :status

      t.timestamps
    end
  end
end
