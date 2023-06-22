class RemoveColumnFromBatchHealthDec < ActiveRecord::Migration[7.0]
  def change
    remove_column :batch_health_decs, :health_dec_id
  end
end
