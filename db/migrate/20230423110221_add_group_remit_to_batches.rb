class AddGroupRemitToBatches < ActiveRecord::Migration[7.0]
  def change
    add_reference :batches, :group_remit, null: false, foreign_key: true
  end
end
