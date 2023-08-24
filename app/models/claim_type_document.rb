class ClaimTypeDocument < ApplicationRecord
  belongs_to :claim_type
  belongs_to :document
end
