class Proposal < ApplicationRecord
  belongs_to :cooperative
  has_one :agreement
  has_many :agreement_benefit
end
