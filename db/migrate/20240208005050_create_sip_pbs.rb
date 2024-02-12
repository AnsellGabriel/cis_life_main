class CreateSipPbs < ActiveRecord::Migration[7.0]
  def change
    create_table :sip_pbs do |t|
      t.belongs_to :sip_ab#, null: false, foreign_key: true
      t.belongs_to :benefit#, null: false, foreign_key: true
      t.decimal :coverage_amount, precision: 15, scale: 2
      t.decimal :premium, precision: 15, scale: 2
      t.string :description

      t.timestamps
    end
  end
end
