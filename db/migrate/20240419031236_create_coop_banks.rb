class CreateCoopBanks < ActiveRecord::Migration[7.0]
  def change
    create_table :coop_banks do |t|
      t.string :account_name
      t.string :account_number
      t.text :address
      t.references :cooperative, null: false, foreign_key: true

      t.timestamps
    end
  end
end
