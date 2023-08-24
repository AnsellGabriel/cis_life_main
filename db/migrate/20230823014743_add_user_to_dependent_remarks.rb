class AddUserToDependentRemarks < ActiveRecord::Migration[7.0]
  def change
    add_reference :dependent_remarks, :user, null: false, foreign_key: true
  end
end
