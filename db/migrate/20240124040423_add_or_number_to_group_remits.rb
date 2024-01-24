class AddOrNumberToGroupRemits < ActiveRecord::Migration[7.0]
  def change
    add_column :group_remits, :or_number, :string
  end
end
