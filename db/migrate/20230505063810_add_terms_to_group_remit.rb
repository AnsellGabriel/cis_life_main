class AddTermsToGroupRemit < ActiveRecord::Migration[7.0]
  def change
    add_column :group_remits, :terms, :integer
  end
end
