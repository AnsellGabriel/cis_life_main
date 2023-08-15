class ProcessRemark < ApplicationRecord
  belongs_to :process_coverage
  belongs_to :user, polymorphic: true

  enum status: {
    pending: 0,
    approved: 1,
    denied: 2,
    for_head_approval: 3,
    for_vp_approval: 4,
    reprocess: 5,
    reprocess_approved: 6
  }

end
