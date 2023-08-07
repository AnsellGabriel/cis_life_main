class ChangeProRemStatusToInt < ActiveRecord::Migration[7.0]
  def change
    change_column :process_remarks, :status, :integer
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
