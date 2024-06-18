class AddOtherAdjustedComputationToLppi < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_insurance_batches, :adjusted_unuse, :decimal, precision: 10, scale: 2, default: 0
    add_column :loan_insurance_batches, :adjusted_coop_sf, :decimal, precision: 10, scale: 2, default: 0
    add_column :loan_insurance_batches, :adjusted_agent_sf, :decimal, precision: 10, scale: 2, default: 0
    add_column :loan_insurance_batches, :adjusted_premium_due, :decimal, precision: 10, scale: 2, default: 0
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
