class CreateGroupRemits < ActiveRecord::Migration[7.0]
  def change
    create_table :group_remits do |t|
      t.string :name
      # t.text :description
      t.references :agreement, null: false, foreign_key: true
      t.references :anniversary, null: false, foreign_key: true

      t.timestamps
    end
  end
end
