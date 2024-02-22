class AddGroupingsToKoopamilyaAb < ActiveRecord::Migration[7.0]
  def change
    add_column :koopamilya_abs, :groupings, :integer
  end
end
