class Payment < ApplicationRecord
  mount_uploader :receipt, ReceiptUploader

  belongs_to :payable, polymorphic: true

  enum status: { for_review: 0, approved: 1, rejected: 2 }
end
