class Claims::ClaimCoverage < ApplicationRecord
  belongs_to :process_claim
  belongs_to :coverageable, polymorphic: true

  Coverage_status = ["Current", "Previous"]
  Status = ["Approve", "Denied", "Pending"]
end
