class PlanUnit < ApplicationRecord
  belongs_to :plan
  has_many :unit_benefits
  has_many :benefits, through: :unit_benefits
  accepts_nested_attributes_for :unit_benefits, reject_if: :all_blank, allow_destroy: true


end
