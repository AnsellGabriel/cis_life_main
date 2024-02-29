class CreateSpecialArrangements < ActiveRecord::Migration[7.0]
  def change
    create_table :special_arrangements do |t|
      t.references :agreement#, null: false, foreign_key: true
      t.text :arrangement

      t.timestamps
    end
  end
end
