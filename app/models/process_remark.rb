class ProcessRemark < ApplicationRecord
  belongs_to :process_coverage
  belongs_to :user, polymorphic: true

  validates :remark, presence: true

  # audited associated_with: :process_coverage

  enum status: {
    pending: 0,
    approved: 1,
    denied: 2,
    for_head_approval: 3,
    for_vp_approval: 4,
    reprocess: 5,
    reprocess_approved: 6,
    reassess: 7,
    refund_request: 8,
    refund_approved: 9
  }

end
