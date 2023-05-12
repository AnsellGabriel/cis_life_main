class CreateBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :batches do |t|
      t.references :group_remit, null: false, foreign_key: true
      t.date :effectivity_date
      t.date :expiry_date
      t.boolean :active
      t.float :coop_sf_amount
      t.float :agent_sf_amount
      t.string :status

      t.timestamps
    end
  end
end
