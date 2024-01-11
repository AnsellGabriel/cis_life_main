class CreateReinsurers < ActiveRecord::Migration[7.0]
  def change
    create_table :reinsurers do |t|
      t.string :name
      t.string :short_name
      t.string :address
      t.string :contact_no

      t.timestamps
    end
  end
end
