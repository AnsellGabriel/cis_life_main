class BatchRemark < ApplicationRecord
  attr_accessor :batch_status, :process_coverage

  validates :remark, presence: true

  # belongs_to :batch
  belongs_to :remarkable, polymorphic: true
  belongs_to :user, polymorphic: true

  enum status: {
    pending: 0,
    denied: 1,
    md_reco: 2,
    request: 3,
    terminated: 4,
    prem_adjust: 5,
    cov_adjust: 6
  }

end
