class AddFullNameToCoopMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :coop_members, :full_name, :string
  end
end
