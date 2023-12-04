class AddAmountInLppiRates < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_insurance_rates, :min_amount, :decimal, precision: 15, scale: 2
    add_column :loan_insurance_rates, :max_amount, :decimal, precision: 15, scale: 2
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
