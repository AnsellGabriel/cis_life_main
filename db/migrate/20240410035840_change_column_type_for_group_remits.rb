class ChangeColumnTypeForGroupRemits < ActiveRecord::Migration[7.0]
  def change
    change_column :group_remits, :official_receipt, :string
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
