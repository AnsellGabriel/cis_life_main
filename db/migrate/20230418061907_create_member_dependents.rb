class CreateMemberDependents < ActiveRecord::Migration[7.0]
  def change
    create_table :member_dependents do |t|
      t.string :last_name
      t.string :first_name
      t.string :middle_name
      t.string :suffix
      t.date :birth_date
      t.string :relationship
      t.references :member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
