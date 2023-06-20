class CreateCoopMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :coop_members do |t|
      t.references :cooperative, null: false, foreign_key: true
      t.references :coop_branch, null: false, foreign_key: true
      t.references :member, null: false, foreign_key: true
      t.date :membership_date
      t.boolean :transferred, default: false

      t.timestamps
    end
  end
end
