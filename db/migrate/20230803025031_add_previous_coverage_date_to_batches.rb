class AddPreviousCoverageDateToBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :batches, :previous_effectivity_date, :date
    add_column :batches, :previous_expiry_date, :date
    remove_column :batches, :batch_remit_id, :date
  end
end
