class AddMarkupRateToLoanRate < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_insurance_rates, :markup_rate, :decimal, precision: 10, scale: 6
    add_column :loan_insurance_rates, :markup_sf, :decimal, precision: 10, scale: 4
  end
end
