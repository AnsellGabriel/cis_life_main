class Claims::ClaimCoverageReinsurance < ApplicationRecord
  belongs_to :claim_reinsurance
  belongs_to :claim_coverage
  belongs_to :reinsurer
end
