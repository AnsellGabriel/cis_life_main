class AddProcessCoverageToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_reference :notifications, :process_coverage#, foreign_key: true
  end
end
