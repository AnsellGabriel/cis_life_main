class AddBatchTypeInBatchRemarks < ActiveRecord::Migration[7.0]
  def change
    add_column :batch_remarks, :batch_type, :string, default: "Batch"
  end
end
