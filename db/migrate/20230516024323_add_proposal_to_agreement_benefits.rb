class AddProposalToAgreementBenefits < ActiveRecord::Migration[7.0]
  def change
    add_reference :agreement_benefits, :proposal, null: false, foreign_key: true
  end
end
