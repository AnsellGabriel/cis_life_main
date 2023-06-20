class RemoveServiceFeeFromAgreementBenefits < ActiveRecord::Migration[7.0]
  def change
    remove_column :agreement_benefits, :coop_sf
    remove_column :agreement_benefits, :agent_sf
  end
end
