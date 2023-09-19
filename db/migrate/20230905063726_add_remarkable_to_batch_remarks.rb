class AddRemarkableToBatchRemarks < ActiveRecord::Migration[7.0]
  def change
    add_reference :batch_remarks, :remarkable, polymorphic: true, null: false
    remove_column :batch_remarks, :batch_id, :bigint
  end
end
