class Batch < ApplicationRecord
  enum status: {
    recent: 0,
    renewal: 1,
    transferred: 2
  }
  # belongs_to :coop_member
  # belongs_to :group_remit
  belongs_to :coop_member
end
