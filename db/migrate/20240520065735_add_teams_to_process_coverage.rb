class AddTeamsToProcessCoverage < ActiveRecord::Migration[7.0]
  def change
    add_reference :process_coverages, :team#, null: false, foreign_key: true
  end
end
