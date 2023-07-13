class AddMainToGroupRemits < ActiveRecord::Migration[7.0]
  def change
    add_column :group_remits, :main, :boolean, default: false
  end
end
