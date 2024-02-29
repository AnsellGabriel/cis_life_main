class AddFieldsToTreasuryBusinessChecks < ActiveRecord::Migration[7.0]
  def change
    add_column :treasury_business_checks, :status, :integer, default: 0
    add_column :treasury_business_checks, :notes, :text
  end
end
