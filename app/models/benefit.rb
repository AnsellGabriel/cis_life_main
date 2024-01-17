class Benefit < ApplicationRecord
  has_many :product_benefits

  has_many :unit_benefits
  has_many :plan_units, through: :unit_benefits

  enum benefit_type: {
    life: 0,
    add: 1,
    burial: 2
  }

  def to_s
    name
  end
end
