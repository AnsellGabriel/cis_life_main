class CreateGroupProposals < ActiveRecord::Migration[7.0]
  def change
    create_table :group_proposals do |t|
      t.references :cooperative#, null: false, foreign_key: true
      t.references :plan#, null: false, foreign_key: true
      t.references :plan_unit#, null: false, foreign_key: true

      t.timestamps
    end
  end
end
