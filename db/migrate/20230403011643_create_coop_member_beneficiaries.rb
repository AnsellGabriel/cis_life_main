class CreateCoopMemberBeneficiaries < ActiveRecord::Migration[7.0]
  def change
    create_table :coop_member_beneficiaries do |t|
      t.string :last_name
      t.string :first_name
      t.string :middle_name
      t.string :suffix
      t.date :birthdate
      t.references :coop_member, null: false, foreign_key: true
      t.string :relationship

      t.timestamps
    end
  end
end
