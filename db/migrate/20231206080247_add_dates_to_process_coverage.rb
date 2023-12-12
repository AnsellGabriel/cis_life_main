class AddDatesToProcessCoverage < ActiveRecord::Migration[7.0]
  def change
    add_column :process_coverages, :process_date, :date
    add_column :process_coverages, :evaluate_date, :date
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
