class AddForMdToBatch < ActiveRecord::Migration[7.0]
  def change
    add_column :batches, :for_md, :boolean, default: false
  end
end
