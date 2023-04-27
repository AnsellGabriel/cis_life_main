class AddCommissionsToAgreements < ActiveRecord::Migration[7.0]
  def change
    add_column :agreements, :agent_service_fee, :decimal
    add_column :agreements, :coop_service_fee, :decimal
  end
end
