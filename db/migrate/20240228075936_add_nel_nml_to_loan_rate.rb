class AddNelNmlToLoanRate < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_insurance_rates, :nel, :decimal, precision: 10, scale: 2
    add_column :loan_insurance_rates, :nml, :decimal, precision: 10, scale: 2
    add_column :loan_insurance_rates, :contestability, :integer
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
