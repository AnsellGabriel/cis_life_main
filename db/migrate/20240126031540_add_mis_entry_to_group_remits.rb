class AddMisEntryToGroupRemits < ActiveRecord::Migration[7.0]
  def change
    add_column :group_remits, :mis_entry, :boolean, deafault: false
    add_column :group_remits, :refund_amount, :decimal, precision: 15, scale: 2
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
