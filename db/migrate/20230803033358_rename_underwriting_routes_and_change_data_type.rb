class RenameUnderwritingRoutesAndChangeDataType < ActiveRecord::Migration[7.0]
  def change
    rename_column :process_coverages, :underwriting_route_id, :und_route

    change_column :process_coverages, :und_route, :integer
  end
end
