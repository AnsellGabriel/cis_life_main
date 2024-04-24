class AddRiAmountAndRiPremToReinsuranceMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :reinsurance_members, :ri_amount, :decimal, precision: 10, scale: 2
    add_column :reinsurance_members, :ri_prem, :decimal, precision: 10, scale: 2
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
