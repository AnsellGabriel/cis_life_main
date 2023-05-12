class AddCoopAndAgentServiceFeeToAgreementBenefits < ActiveRecord::Migration[7.0]
  def change
    add_column :agreement_benefits, :coop_sf, :decimal, precision: 10, scale: 2
    add_column :agreement_benefits, :agent_sf, :decimal, precision: 10, scale: 2
  end
end
