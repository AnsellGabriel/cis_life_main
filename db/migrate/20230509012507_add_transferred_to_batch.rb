class AddTransferredToBatch < ActiveRecord::Migration[7.0]
  def change
    add_column :batches, :transferred, :boolean
  end
end
