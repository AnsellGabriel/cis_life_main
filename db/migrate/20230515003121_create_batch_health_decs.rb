class CreateBatchHealthDecs < ActiveRecord::Migration[7.0]
  def change
    create_table :batch_health_decs do |t|
      t.boolean :ans_q1
      t.boolean :ans_q2
      t.boolean :ans_q3
      t.string :ans_q3_desc
      t.boolean :ans_q4
      t.string :ans_q4_desc
      t.boolean :ans_q5_a
      t.string :ans_q5_a_desc
      t.boolean :ans_q5_b
      t.string :ans_q5_b_desc
      t.references :batch, null: false, foreign_key: true

      t.timestamps
    end
  end
end
