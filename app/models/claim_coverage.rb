class ClaimCoverage < ApplicationRecord
  belongs_to :process_claim

  belongs_to :coverageable, polymorphic: true
end
