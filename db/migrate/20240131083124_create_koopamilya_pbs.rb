class CreateKoopamilyaPbs < ActiveRecord::Migration[7.0]
  def change
    create_table :koopamilya_pbs do |t|
      t.belongs_to :koopamilya_ab#, null: false, foreign_key: true
      t.decimal :coverage_amount, precision: 15, scale: 2 
      t.belongs_to :benefit#, null: false, foreign_key: true

      t.timestamps
    end
  end
end
