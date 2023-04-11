class AddColumnToCoopMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :coop_members, :birth_place, :string
    add_column :coop_members, :sss_no, :integer
    add_column :coop_members, :tin_no, :integer
    add_column :coop_members, :address, :string
    add_column :coop_members, :civil_status, :string
    add_column :coop_members, :legal_spouse, :string
    add_column :coop_members, :height, :float
    add_column :coop_members, :weight, :float
    add_column :coop_members, :occupation, :string
    add_column :coop_members, :employer, :string
    add_column :coop_members, :work_address, :string
    add_column :coop_members, :work_phone_number, :integer
  end
end
