class AddAgreementBenefitToBatchDependent < ActiveRecord::Migration[7.0]
  def change
    add_reference :batch_dependents, :agreement_benefit, null: false, foreign_key: true
  end
end
