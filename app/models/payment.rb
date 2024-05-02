class Payment < ApplicationRecord
  mount_uploader :receipt, ReceiptUploader

  belongs_to :payable, polymorphic: true
  # belongs_to :group_remit, -> { includes(:payments).where(payments: { payable_type: ["Remittance", "LoanInsurance::GroupRemit"]})}, foreign_key: :payable_id
  belongs_to :group_remit, -> { where(group_remits: { type: ["Remittance", "LoanInsurance::GroupRemit"]}).includes(:payments)}, foreign_key: 'payable_id'

  has_many :remarks, as: :remarkable, dependent: :destroy
  has_many :entries, class_name: "Treasury::CashierEntry", as: :entriable, dependent: :destroy

  enum status: { for_review: 0, approved: 1, rejected: 2 }

  def to_s
    coop.name
  end

  def reject
    self.rejected!
    self.payable.reupload_payment!
    Notification.create(notifiable: self.coop, message: "#{self.payable.name} payment rejected. Please see remarks and re-upload proof of payment.")
  end

  # def paid

  #   group_remit = self.payable

  #   ActiveRecord::Base.transaction do
  #     self.approved!
  #     group_remit.paid!
  #     Notification.create!(notifiable: group_remit.agreement.cooperative, message: "#{group_remit.name} payment verified.")

  #     if group_remit.type == "LoanInsurance::GroupRemit"
  #       group_remit.update_members_total_loan
  #       group_remit.update_batch_coverages
  #       group_remit.terminate_unused_batches(current_user)
  #     else
  #       group_remit.update_batch_remit
  #       group_remit.update_batch_coverages
  #     end
  #   end

  # end

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
