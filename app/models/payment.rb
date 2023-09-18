class Payment < ApplicationRecord
  mount_uploader :receipt, ReceiptUploader

  belongs_to :payable, polymorphic: true
end
