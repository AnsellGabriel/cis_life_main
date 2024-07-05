class ChangeTreasuryDefaults < ActiveRecord::Migration[7.0]
  def change
    change_column_default :treasury_cashier_entries, :service_fee, 0
    change_column_default :treasury_cashier_entries, :deposit, 0
  end
end
