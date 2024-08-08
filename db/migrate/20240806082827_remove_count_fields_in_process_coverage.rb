class RemoveCountFieldsInProcessCoverage < ActiveRecord::Migration[7.0]
  def change
    remove_column :process_coverages, :approved_count
    remove_column :process_coverages, :approved_total_coverage
    remove_column :process_coverages, :approved_total_prem
    remove_column :process_coverages, :denied_count
    remove_column :process_coverages, :denied_total_coverage
    remove_column :process_coverages, :denied_total_prem
  end
end
