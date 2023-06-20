class CreateAgreementBenefits < ActiveRecord::Migration[7.0]
  def change
    create_table :agreement_benefits do |t|
      t.references :agreements#, null: false, foreign_key: true
      t.references :plans#, null: false, foreign_key: true
      t.references :proposals#, null: false, foreign_key: true
      t.references :options#, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.integer :min_age
      t.integer :max_age
      t.string :insured_type

      t.timestamps
    end
  end
end
