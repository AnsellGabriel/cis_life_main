class AddFieldsToRiBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :reinsurance_batches, :ri_effectivity, :date
    add_column :reinsurance_batches, :ri_expiry, :date
    add_column :reinsurance_batches, :ri_terms, :integer
  end
end
