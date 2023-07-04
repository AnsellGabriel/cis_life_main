class AddResidencyToBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :batches, :residency, :integer
  end
end
