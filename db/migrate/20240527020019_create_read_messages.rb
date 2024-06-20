class CreateReadMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :read_messages do |t|
      t.references :user, null: false, foreign_key: true
      t.references :claim_remark, null: false, foreign_key: true

      t.timestamps
    end
    add_index :read_messages, [:user_id, :claim_remark_id], unique: true
  end
end
