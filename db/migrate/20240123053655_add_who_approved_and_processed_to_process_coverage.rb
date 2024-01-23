class AddWhoApprovedAndProcessedToProcessCoverage < ActiveRecord::Migration[7.0]
  def change
    add_reference :process_coverages, :who_processed, foreign_key: { to_table: :employees }
    add_reference :process_coverages, :who_approved, foreign_key: { to_table: :employees }
  end
end
