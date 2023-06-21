class CreateAgreementBenefits < ActiveRecord::Migration[7.0]
  def change
    create_table :agreement_benefits do |t|
      t.references :agreement#, null: false, foreign_key: true
      t.references :plan#, null: false, foreign_key: true
      t.references :proposal#, null: false, foreign_key: true
      t.references :option#, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.integer :min_age
      t.integer :max_age
      t.integer :insured_type

      t.timestamps
    end
  end
end
