class CreateReinsuranceMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :reinsurance_members do |t|
      t.references :reinsurance#, null: false, foreign_key: true
      t.references :member#, null: false, foreign_key: true
      t.decimal :total_loan_amount, precision: 20, scale: 2

      t.timestamps
    end
  end
end
