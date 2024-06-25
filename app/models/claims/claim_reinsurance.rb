class Claims::ClaimReinsurance < ApplicationRecord
  belongs_to :process_claim, class_name: "Claims::ProcessClaim"
  has_many :claim_coverage_reinsurances, dependent: :destroy, class_name: "Claims::ClaimCoverageReinsurance"

  enum status: {
    pending: 0,
    accomplished: 1
  }
end
