class AddInsuredTypeToAgreementBenefits < ActiveRecord::Migration[7.0]
  def change
    add_column :agreement_benefits, :insured_type, :integer
  end
end
