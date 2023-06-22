class ChangeColumnsInBatchHealthDec < ActiveRecord::Migration[7.0]
  def change
    remove_column :batch_health_decs, :answer_desc
    change_column :batch_health_decs, :answer, :text
    add_reference :batch_health_decs, :answerable, polymorphic: true, null: false
  end
end
