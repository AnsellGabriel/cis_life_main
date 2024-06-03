class AddAdjustmentsToLppi < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_insurance_batches, :adjusted_prem, :decimal, precision: 10, scale: 2, default: 0
    add_column :loan_insurance_batches, :adjusted_cov, :decimal, precision: 10, scale: 2, default: 0
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
