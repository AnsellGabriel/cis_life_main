class ClaimCoverage < ApplicationRecord
  belongs_to :process_claim
  Coverage_status = ["Current", "Previous"]
  Status = ["Approve", "Denied", "Pending"]
  # belongs_to :coverageable, polymorphic: true
end
