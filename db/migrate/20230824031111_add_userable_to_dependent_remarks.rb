class AddUserableToDependentRemarks < ActiveRecord::Migration[7.0]
  def change
    add_reference :dependent_remarks, :userable, polymorphic: true, null: false
  end
end
