class ClaimRemark < ApplicationRecord
  belongs_to :process_claim
  belongs_to :user
  
  validates :remark, presence: true

  enum status: {
    approved: 0,
    denied: 1,
    pending: 2,
    reconsider: 3
  }

  def self.get_status(i) 
    status.key(i)
  end
end
