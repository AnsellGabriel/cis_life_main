class AddColumnToBatchDependents < ActiveRecord::Migration[7.0]
  def change
    add_reference :batch_dependents, :member_dependent, null: false, foreign_key: true
    add_column :batch_dependents, :premium, :decimal, precision: 10, scale: 2
    add_column :batch_dependents, :beneficiary, :boolean
    add_column :batch_dependents, :dependent, :boolean
  end
end
