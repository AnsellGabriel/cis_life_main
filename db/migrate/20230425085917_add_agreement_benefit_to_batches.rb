class AddAgreementBenefitToBatches < ActiveRecord::Migration[7.0]
  def change
    add_reference :batches, :agreement_benefit, null: false, foreign_key: true
  end
end
