class CreateBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :batches do |t|
      t.references :coop_member, null: false, foreign_key: true
      t.references :group_remit, null: false, foreign_key: true
      t.date :effectivity_date
      t.string :expiry_date
      t.boolean :active
      t.float :coop_sf_amount
      t.float :agent_sf_amount

      t.timestamps
    end
  end
end
