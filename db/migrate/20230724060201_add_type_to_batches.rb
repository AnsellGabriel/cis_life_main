class AddTypeToBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :batches, :type, :string
  end
end
