class AddTypeToGroupRemit < ActiveRecord::Migration[7.0]
  def change
    add_column :group_remits, :type, :string
  end
end
