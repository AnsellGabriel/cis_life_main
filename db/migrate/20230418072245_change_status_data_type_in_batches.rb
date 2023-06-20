class ChangeStatusDataTypeInBatches < ActiveRecord::Migration[7.0]
  def change
    change_column :batches, :status, :integer
  end
end
