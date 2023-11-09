class Payment < ApplicationRecord
  mount_uploader :receipt, ReceiptUploader

  belongs_to :payable, polymorphic: true

  has_many :remarks, as: :remarkable, dependent: :destroy

  enum status: { for_review: 0, approved: 1, rejected: 2 }

  def reject
    self.rejected!
    self.payable.reupload_payment!
    Notification.create(notifiable: self.payable.cooperative, message: "#{self.payable.name} payment rejected.")
  end
end
