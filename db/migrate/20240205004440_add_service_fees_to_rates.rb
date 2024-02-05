class AddServiceFeesToRates < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_insurance_rates, :coop_sf, :decimal, precision: 10, scale: 2
    add_column :loan_insurance_rates, :agent_sf, :decimal, precision: 10, scale: 2
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
