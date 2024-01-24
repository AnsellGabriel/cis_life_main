class AddBenefitTypeToBenefits < ActiveRecord::Migration[7.0]
  def change
    add_column :benefits, :benefit_type, :integer
  end
end
