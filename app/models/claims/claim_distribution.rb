class Claims::ClaimDistribution < ApplicationRecord
  belongs_to :process_claim
  belongs_to :coop_bank

  validates_presence_of :name, :amount
end
