class ChangeColumnTypeFromAgreementBenefits < ActiveRecord::Migration[7.0]
  def change
    change_column :agreement_benefits, :min_age, :decimal, precision: 10, scale: 3
    change_column :agreement_benefits, :max_age, :decimal, precision: 10, scale: 3
    change_column :agreement_benefits, :exit_age, :decimal, precision: 10, scale: 3
  end
end
