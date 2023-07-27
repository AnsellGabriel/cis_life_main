class CreateUserLevels < ActiveRecord::Migration[7.0]
  def change
    create_table :user_levels do |t|
      t.references :user#, null: false, foreign_key: true
      t.references :authority_level#, null: false, foreign_key: true
      t.boolean :active

      t.timestamps
    end
  end
end
