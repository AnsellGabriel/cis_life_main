class AddGenderToCoopMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :coop_members, :gender, :string
  end
end
