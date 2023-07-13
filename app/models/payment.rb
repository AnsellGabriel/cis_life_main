class Payment < ApplicationRecord
  mount_uploader :receipt, ReceiptUploader

  belongs_to :group_remit

  enum status: {
    payment_verification: 0,
    payment_verified: 1,
    payment_denied: 2
  }
  
end
