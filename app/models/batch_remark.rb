class BatchRemark < ApplicationRecord
  attr_accessor :batch_status, :process_coverage

  validates :remark, presence: true

  belongs_to :batch
  belongs_to :user, polymorphic: true


  enum status: {
    pending: 0,
    denied: 1,
    md_reco: 2,
    request: 3
  }

end
