class AddInsuranceStatusToBatchDependents < ActiveRecord::Migration[7.0]
  def change
    add_column :batch_dependents, :insurance_status, :integer, default: 3
  end
end
