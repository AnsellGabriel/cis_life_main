class AddDateSubmittedToGroupRemit < ActiveRecord::Migration[7.0]
  def change
    add_column :group_remits, :date_submitted, :date
  end
end
