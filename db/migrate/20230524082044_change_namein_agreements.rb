class ChangeNameinAgreements < ActiveRecord::Migration[7.0]
  def change
    rename_column :agreements, :name, :moa_no
  end
end
