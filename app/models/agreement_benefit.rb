class AgreementBenefit < ApplicationRecord
	validates_presence_of :name, :premium, :coop_sf, :agent_sf

  has_many :batches
end
