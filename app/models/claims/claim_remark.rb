class Claims::ClaimRemark < ApplicationRecord
  belongs_to :process_claim
  belongs_to :user

  has_many :read_messages
  has_many :readers, through: :read_messages, source: :user

  validates :remark, presence: true

  enum status: {
    approved: 0,
    denied: 1,
    pending: 2,
    reconsider: 3
  }

  scope :unread, -> { where(read: false) }
  
  def self.get_status(i)
    status.key(i)
  end
end
