class AddCooperativeToGroupRemits < ActiveRecord::Migration[7.0]
  def change
    add_reference :group_remits, :cooperative, null: false, foreign_key: true
  end
end
