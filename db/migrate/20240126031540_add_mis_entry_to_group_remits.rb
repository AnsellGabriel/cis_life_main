class AddMisEntryToGroupRemits < ActiveRecord::Migration[7.0]
  def change
    add_column :group_remits, :mis_entry, :boolean, deafault: false
  end
end
