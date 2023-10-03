class MemberImportTracker < ApplicationRecord
  belongs_to :trackable, polymorphic: true
end
