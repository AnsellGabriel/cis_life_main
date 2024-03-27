class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true
  belongs_to :process_coverage, optional: true, dependent: :destroy

  scope :unread, -> { where(viewed: false) }
end
