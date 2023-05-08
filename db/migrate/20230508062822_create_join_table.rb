class CreateJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :agreements, :coop_members do |t|
      t.index [:agreement_id, :coop_member_id]
      t.index [:coop_member_id, :agreement_id]
    end
  end
end
