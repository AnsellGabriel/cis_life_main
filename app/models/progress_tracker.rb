class ProgressTracker < ApplicationRecord
  belongs_to :trackable, polymorphic: true
end
