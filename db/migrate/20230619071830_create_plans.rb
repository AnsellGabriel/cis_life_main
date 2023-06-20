class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.text :description
      t.integer :entry_age_from
      t.integer :entry_age_to
      t.integer :exit_age
      t.integer :min_participation
      t.string :acronym

      t.timestamps
    end
  end
end
