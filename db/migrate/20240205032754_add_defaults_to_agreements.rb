class AddDefaultsToAgreements < ActiveRecord::Migration[7.0]
  def change
    add_column :agreements, :minimum_term, :integer, default: 0
    add_column :agreements, :minimum_premium, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
