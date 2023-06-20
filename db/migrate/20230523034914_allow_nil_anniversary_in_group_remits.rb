class AllowNilAnniversaryInGroupRemits < ActiveRecord::Migration[7.0]
  def change
    change_column :group_remits, :anniversary_id, :integer, null: true
  end
end
