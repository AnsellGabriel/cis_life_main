class AddPremiumsAndCommissionsToGroupRemit < ActiveRecord::Migration[7.0]
  def change
    add_column :group_remits, :gross_premium, :decimal, precision: 10, scale: 2
    add_column :group_remits, :net_premium, :decimal, precision: 10, scale: 2
    add_column :group_remits, :coop_commission, :decimal, precision: 10, scale: 2
    add_column :group_remits, :agent_commission, :decimal, precision: 10, scale: 2
  end
end
