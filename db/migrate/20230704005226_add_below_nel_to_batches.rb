class AddBelowNelToBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :batches, :below_nel, :boolean, default: false
  end
end
