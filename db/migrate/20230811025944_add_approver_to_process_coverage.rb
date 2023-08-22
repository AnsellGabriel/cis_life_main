class AddApproverToProcessCoverage < ActiveRecord::Migration[7.0]
  def change
    add_reference :process_coverages, :approver, foreign_key: { to_table: :employees }#, null: false, foreign_key: true
  end
end
