class ClaimRemark < ApplicationRecord
  belongs_to :process_claim
  belongs_to :user

  enum status: {
    approved: 0,
    denied: 1,
    pending: 2,
    reconsider: 3
  }
end
