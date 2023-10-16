class ChangeEntryTypeToInt < ActiveRecord::Migration[7.0]
  def change
    change_column :process_claims, :entry_type, :integer
  end
end
