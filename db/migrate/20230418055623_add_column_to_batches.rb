class AddColumnToBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :batches, :premium, :decimal, precision: 10, scale: 2
  end
end
