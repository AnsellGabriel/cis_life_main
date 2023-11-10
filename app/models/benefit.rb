class Benefit < ApplicationRecord
  has_many :product_benefits

  has_many :unit_benefits
  has_many :plan_units, through: :unit_benefits

  def to_s
    name
  end
end
