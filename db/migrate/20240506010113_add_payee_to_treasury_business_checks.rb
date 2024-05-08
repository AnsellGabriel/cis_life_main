class AddPayeeToTreasuryBusinessChecks < ActiveRecord::Migration[7.0]
  def change
    add_column :treasury_business_checks, :payee, :string
  end
end
