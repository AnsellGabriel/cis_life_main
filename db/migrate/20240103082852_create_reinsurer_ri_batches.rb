class CreateReinsurerRiBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :reinsurer_ri_batches do |t|
      t.references :reinsurance_batch#, null: false, foreign_key: true
      t.references :reinsurer#, null: false, foreign_key: true

      t.timestamps
    end
  end
end
