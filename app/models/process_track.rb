class ProcessTrack < ApplicationRecord
  belongs_to :user
  belongs_to :trackable, polymorphic: true, optional: true

  enum status: {
    approved: 0,
    denied: 1,
    reconsider_approved: 2,
    reconsider_denied: 3,
    pending: 4,
    reconsider: 5
  }
end
