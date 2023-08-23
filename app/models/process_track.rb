class ProcessTrack < ApplicationRecord
  belongs_to :user
  belongs_to :trackable, polymorphic: true, optional: true
end
