class RenameBeneficiaryAndDependentFromBatchDependents < ActiveRecord::Migration[7.0]
  def change
    rename_column :batch_dependents, :beneficiary, :is_beneficiary
    rename_column :batch_dependents, :dependent, :is_dependent

  end
end
