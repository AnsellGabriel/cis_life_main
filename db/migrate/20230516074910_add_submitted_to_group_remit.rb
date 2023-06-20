class AddSubmittedToGroupRemit < ActiveRecord::Migration[7.0]
  def change
    add_column :group_remits, :submitted, :boolean
  end
end
