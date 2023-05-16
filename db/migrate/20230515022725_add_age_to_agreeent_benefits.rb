class AddAgeToAgreeentBenefits < ActiveRecord::Migration[7.0]
  def change
    add_column :agreement_benefits, :min_age, :integer
    add_column :agreement_benefits, :max_age, :integer
    remove_column :agreement_benefits, :premium
  end
end
