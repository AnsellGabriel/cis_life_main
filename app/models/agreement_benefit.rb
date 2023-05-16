class AgreementBenefit < ApplicationRecord
	validates_presence_of :name

  has_many :batches
  has_one :product_benefit

  belongs_to :agreement
  belongs_to :proposal
end
