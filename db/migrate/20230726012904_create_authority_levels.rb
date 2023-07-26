class CreateAuthorityLevels < ActiveRecord::Migration[7.0]
  def change
    create_table :authority_levels do |t|
      t.string :name
      t.decimal :maxAmount, precision: 10, scale: 2

      t.timestamps
    end
  end
end
