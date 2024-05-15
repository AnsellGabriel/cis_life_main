class Claims::ClaimCause < ApplicationRecord
  belongs_to :process_claim
  # validates_presence_of :name
end
