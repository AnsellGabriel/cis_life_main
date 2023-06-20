class CreateAgentGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :agent_groups do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
