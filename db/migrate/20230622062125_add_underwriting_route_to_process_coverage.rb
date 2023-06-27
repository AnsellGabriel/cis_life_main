class AddUnderwritingRouteToProcessCoverage < ActiveRecord::Migration[7.0]
  def change
    add_reference :process_coverages, :underwriting_route#, null: false, foreign_key: true
  end
end
