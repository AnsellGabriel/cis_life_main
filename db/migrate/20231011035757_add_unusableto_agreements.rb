class AddUnusabletoAgreements < ActiveRecord::Migration[7.0]
  def change
    add_column :agreements, :unusable, :boolean, default: false
  end
end
