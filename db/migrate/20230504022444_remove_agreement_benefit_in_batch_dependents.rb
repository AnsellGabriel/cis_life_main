class RemoveAgreementBenefitInBatchDependents < ActiveRecord::Migration[7.0]
  def change
    remove_column :batch_dependents, :agreement_benefit_id
  end
end
