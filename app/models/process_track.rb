class ProcessTrack < ApplicationRecord
  belongs_to :user
  belongs_to :trackable, polymorphic: true, optional: true

  enum status: {
    approved: 0,
    denied: 1
  }
end
