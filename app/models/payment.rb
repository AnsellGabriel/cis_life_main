class Payment < ApplicationRecord
  mount_uploader :receipt, ReceiptUploader

  belongs_to :payable, polymorphic: true

  has_many :remarks, as: :remarkable, dependent: :destroy
  has_many :entries, class_name: "Treasury::CashierEntry", as: :entriable, dependent: :destroy

  enum status: { for_review: 0, approved: 1, rejected: 2 }

  def reject
    self.rejected!
    self.payable.reupload_payment!
    Notification.create(notifiable: self.payable.cooperative, message: "#{self.payable.name} payment rejected. Please re-upload proof of payment.")
  end

  def coop
    payable.agreement.cooperative
  end

  def plan
    payable.agreement.plan
  end

  def agent
    payable.agreement.agent
  end
end
