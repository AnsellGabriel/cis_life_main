class AddBatchesCountToAgreementBenefits < ActiveRecord::Migration[7.0]
  def change
    add_column :agreement_benefits, :batches_count, :integer
  end
end
