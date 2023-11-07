class CreatePayees < ActiveRecord::Migration[7.0]
  def change
    create_table :payees do |t|
      t.string :name
      t.string :address
      t.text :description
      t.string :contact_number

      t.timestamps
    end
  end
end
