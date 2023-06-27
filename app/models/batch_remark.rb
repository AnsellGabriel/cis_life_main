class BatchRemark < ApplicationRecord
  attr_accessor :batch_status, :process_coverage

  belongs_to :batch
  belongs_to :user, polymorphic: true

  validates :remark, presence: true

  enum status: {
    pending: 0,
    denied: 1,
    md_reco: 2
  }

end
