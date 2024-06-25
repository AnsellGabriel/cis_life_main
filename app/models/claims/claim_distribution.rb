class Claims::ClaimDistribution < ApplicationRecord
  belongs_to :process_claim

  validates_presence_of :name, :amount
end
