class RemoveAgreementBenefitInBatches < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :batches, :agreement_benefits

    # remove user_id column
    remove_column :batches, :agreement_benefit_id
  end
end
