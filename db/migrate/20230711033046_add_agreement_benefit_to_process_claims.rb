class AddAgreementBenefitToProcessClaims < ActiveRecord::Migration[7.0]
  def change
    add_reference :process_claims, :agreement_benefit#, null: false, foreign_key: true
  end
end
