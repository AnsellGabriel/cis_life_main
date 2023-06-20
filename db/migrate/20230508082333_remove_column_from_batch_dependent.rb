class RemoveColumnFromBatchDependent < ActiveRecord::Migration[7.0]
  def change
    remove_column :batch_dependents, :is_dependent, :boolean
    remove_column :batch_dependents, :is_beneficiary, :boolean
  end
end
