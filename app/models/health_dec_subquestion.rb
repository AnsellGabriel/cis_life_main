class HealthDecSubquestion < ApplicationRecord
  belongs_to :health_dec
  has_many :batch_health_decs, as: :answerable, dependent: :destroy
  has_many :dependent_health_decs, as: :answerable, dependent: :destroy
end
