class CreateJoinTableBatchCoopMember < ActiveRecord::Migration[7.0]
  def change
    create_join_table :batches, :coop_members do |t|
      t.index [:batch_id, :coop_member_id]
      t.index [:coop_member_id, :batch_id]
    end
  end
end
