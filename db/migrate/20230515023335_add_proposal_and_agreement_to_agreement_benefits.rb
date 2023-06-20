class AddProposalAndAgreementToAgreementBenefits < ActiveRecord::Migration[7.0]
  def change
    add_reference :agreement_benefits, :agreement, null: false, foreign_key: true
  end
end
