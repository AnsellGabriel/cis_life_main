class AddReproccesToProcessCoverages < ActiveRecord::Migration[7.0]
  def change
    add_column :process_coverages, :reprocess, :boolean
  end
end
