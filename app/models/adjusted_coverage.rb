class AdjustedCoverage < ApplicationRecord
  belongs_to :coverageable, polymorphic: true

  enum status: {
    pending: 0,
    approved: 1,
    denied: 2
  }
end
