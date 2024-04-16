class AddMisUserToGroupRemits < ActiveRecord::Migration[7.0]
  def change
    add_column :group_remits, :mis_user, :integer
  end
end
