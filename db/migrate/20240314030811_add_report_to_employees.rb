class AddReportToEmployees < ActiveRecord::Migration[7.0]
  def change
    add_column :employees, :report, :string
  end
end
