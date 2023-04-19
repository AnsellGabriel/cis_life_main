class AddCoopMemberToBatches < ActiveRecord::Migration[7.0]
  def change
    add_reference :batches, :coop_member, null: false, foreign_key: true
  end
end
