class AgreementBenefit < ApplicationRecord
	validates_presence_of :name, :min_age, :max_age, :insured_type

  has_many :batches
  has_many :product_benefits

  belongs_to :agreement
  belongs_to :proposal
end
