class RemoveAnniversaryForeignKeyFromGroupRemit < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :group_remits, :anniversaries
  end
end
