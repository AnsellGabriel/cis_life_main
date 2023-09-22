class AddRiDateToReinsuranceBatch < ActiveRecord::Migration[7.0]
  def change
    add_column :reinsurance_batches, :ri_date, :date
  end
end
