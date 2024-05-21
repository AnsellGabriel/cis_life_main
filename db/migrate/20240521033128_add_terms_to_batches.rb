class AddTermsToBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :batches, :terms, :integer
  end
end
