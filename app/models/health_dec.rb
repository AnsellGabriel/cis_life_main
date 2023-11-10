class HealthDec < ApplicationRecord
  has_many :health_dec_subquestions, dependent: :destroy
  has_many :batch_health_decs, as: :answerable, dependent: :destroy
  has_many :dependent_health_decs, as: :answerable, dependent: :destroy
end
