class ChangeColumnTypeInAgreements < ActiveRecord::Migration[7.0]
  def change
    change_column :agreements, :entry_age_from, :decimal, precision: 5, scale: 2
    change_column :agreements, :entry_age_to, :decimal, precision: 5, scale: 2
    change_column :agreements, :exit_age, :decimal, precision: 5, scale: 2
  end
end
