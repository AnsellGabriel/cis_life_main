class AddColumnsToAgreements < ActiveRecord::Migration[7.0]
  def change
    add_column :agreements, :coop_sf, :decimal, precision: 10, scale: 2
    add_column :agreements, :agent_sf, :decimal, precision: 10, scale: 2
    add_column :agreements, :minimum_participation, :integer
  end
end
