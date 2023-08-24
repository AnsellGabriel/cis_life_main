class ClaimTypeBenefit < ApplicationRecord
  belongs_to :claim_type
  belongs_to :benefit
end
