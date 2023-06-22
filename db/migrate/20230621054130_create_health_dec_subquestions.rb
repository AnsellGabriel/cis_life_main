class CreateHealthDecSubquestions < ActiveRecord::Migration[7.0]
  def change
    create_table :health_dec_subquestions do |t|
      t.references :health_dec, null: false, foreign_key: true
      t.text :question
      t.timestamps
    end
  end
end
