class AddOldCodeToCooperative < ActiveRecord::Migration[7.0]
  def change
    add_column :cooperatives, :old_code, :string
  end
end
