class AddDatesToGroupRemit < ActiveRecord::Migration[7.0]
  def change
    add_column :group_remits, :effectivity_date, :date
    add_column :group_remits, :expiry_date, :date
  end
end
