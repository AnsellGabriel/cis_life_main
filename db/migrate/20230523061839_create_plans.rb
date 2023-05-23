class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.text :description
      t.string :acronym
      t.timestamps
    end
  end
end
