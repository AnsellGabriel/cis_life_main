class AddDeceasedToCoopMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :coop_members, :deceased, :boolean, default: false
  end
end
