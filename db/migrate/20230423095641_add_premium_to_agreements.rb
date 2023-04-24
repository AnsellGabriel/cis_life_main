class AddPremiumToAgreements < ActiveRecord::Migration[7.0]
  def change
    add_column :agreements, :premium, :decimal
  end
end
