class AddCoopAndAgentServiceFeeToAgreementBenefits < ActiveRecord::Migration[7.0]
  def change
    add_column :agreement_benefits, :coop_sf, :decimal
    add_column :agreement_benefits, :agent_sf, :decimal
  end
end
