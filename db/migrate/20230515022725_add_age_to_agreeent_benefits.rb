class AddAgeToAgreeentBenefits < ActiveRecord::Migration[7.0]
  def change
    remove_column :agreement_benefits, :premium
  end
end
