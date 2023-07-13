class CreateAgreementsCoopMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :agreements_coop_members do |t|
      t.references :agreement, null: false, foreign_key: true
      t.references :coop_member, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
