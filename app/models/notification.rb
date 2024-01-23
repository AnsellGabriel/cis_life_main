class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(viewed: false) }
end
