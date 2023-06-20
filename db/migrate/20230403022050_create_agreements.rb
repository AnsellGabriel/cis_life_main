class CreateAgreements < ActiveRecord::Migration[7.0]
  def change
    create_table :agreements do |t|
      t.references :plan#, null: false, foreign_key: true
      t.references :cooperative#, null: false, foreign_key: true
      t.references :agent#, null: false, foreign_key: true
      t.string :moa_no
      t.integer :contestability
      t.decimal :nel, precision: 12, scale: 2
      t.decimal :nml, precision: 12, scale: 2
      t.string :anniversary_type
      t.boolean :transferred
      t.date :transferred_date
      t.string :previous_provider
      t.string :comm_type
      t.boolean :claims_fund
      t.integer :entry_age_from
      t.integer :entry_age_to
      t.integer :exit_age
      # please add claims_fund_balance
      t.timestamps
    end
  end
end
