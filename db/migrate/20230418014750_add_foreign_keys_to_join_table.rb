class AddForeignKeysToJoinTable < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :batches_coop_members, :batches
    add_foreign_key :batches_coop_members, :coop_members
  end
end
