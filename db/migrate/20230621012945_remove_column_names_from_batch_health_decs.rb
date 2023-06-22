class RemoveColumnNamesFromBatchHealthDecs < ActiveRecord::Migration[7.0]
  def change
    remove_columns :batch_health_decs, :ans_q1, :ans_q2, :ans_q3, :ans_q3_desc, :ans_q4, :ans_q4_desc, :ans_q5_a, :ans_q5_a_desc, :ans_q5_b, :ans_q5_b_desc
    add_column :batch_health_decs, :answer, :boolean
    add_column :batch_health_decs, :answer_desc, :text
  end
end
