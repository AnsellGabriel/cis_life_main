class AddBatchRemitIdToBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :batches, :batch_remit_id, :integer
  end
end
