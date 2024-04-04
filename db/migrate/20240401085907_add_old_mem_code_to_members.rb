class AddOldMemCodeToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :coop_members, :old_mem_code, :string
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
