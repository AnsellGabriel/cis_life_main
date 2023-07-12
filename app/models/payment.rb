class Payment < ApplicationRecord
  mount_uploader :receipt, ReceiptUploader

  belongs_to :group_remit
end
