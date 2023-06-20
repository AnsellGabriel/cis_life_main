class RemoveServiceFeesFromAgreement < ActiveRecord::Migration[7.0]
  def change
    remove_column :agreements, :coop_service_fee
    remove_column :agreements, :agent_service_fee
    remove_column :agreements, :premium
  end
end
