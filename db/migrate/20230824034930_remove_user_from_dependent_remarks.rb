class RemoveUserFromDependentRemarks < ActiveRecord::Migration[7.0]
  def change
    remove_column :dependent_remarks, :user_id, :bigint
  end
end
