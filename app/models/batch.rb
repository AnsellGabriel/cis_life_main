class Batch < ApplicationRecord
  enum status: {
    recent: 0,
    renewal: 1,
    transferred: 2
  }
  # belongs_to :coop_member
  # belongs_to :group_remit
  has_and_belongs_to_many :coop_members
end
