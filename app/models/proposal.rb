class Proposal < ApplicationRecord
  belongs_to :cooperative

  has_one :agreement_benefit
end
