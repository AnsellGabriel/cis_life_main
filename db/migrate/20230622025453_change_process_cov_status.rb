class ChangeProcessCovStatus < ActiveRecord::Migration[7.0]
  # def change
  #   change_column :process_coverages, :status, :integer
  #   #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  # end

  def up
    change_column :process_coverages, :status, :integer
  end

  def down
    change_column :process_coverages, :status, :string
  end
end
