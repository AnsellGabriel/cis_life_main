class AddWithDependentToAgreementBenefits < ActiveRecord::Migration[7.0]
  def change
    add_column :agreement_benefits, :with_dependent, :boolean, default: false
  end
end
