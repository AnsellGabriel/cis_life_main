class CreateReinsuranceBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :reinsurance_batches do |t|
      t.references :reinsurance#, null: false, foreign_key: true
      t.references :batch#, null: false, foreign_key: true

      t.timestamps
    end
  end
end
