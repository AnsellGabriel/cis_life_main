class AddPremiumToAgreementBenefits < ActiveRecord::Migration[7.0]
  def change
    add_column :agreement_benefits, :premium, :decimal, precision: 10, scale: 2
  end
end
