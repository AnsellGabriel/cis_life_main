class AddCommissionsToAgreements < ActiveRecord::Migration[7.0]
  def change
    add_column :agreements, :agent_service_fee, :decimal, precision: 10, scale: 2
    add_column :agreements, :coop_service_fee, :decimal, precision: 10, scale: 2
  end
end
