class Accounting::Voucher < ApplicationRecord
  validates_presence_of :date_voucher, :particulars, :voucher, :payable_type, :payable_id,
                        :particulars, :status, :audit, :accountant_id, :type, :branch, :global_payable, :amount

  belongs_to :payable, polymorphic: true
  belongs_to :voucher_request, class_name: "Accounting::VoucherRequest", optional: true, foreign_key: :request_id
  belongs_to :treasury_account, class_name: "Treasury::Account", foreign_key: :treasury_account_id, optional: true

  has_many :general_ledgers, as: :ledgerable
  has_many :remarks, as: :remarkable, dependent: :destroy

  enum audit: { for_audit: 0, approved: 1, pending_audit: 2 }
  enum status: { pending: 0, posted: 1, cancelled: 2, for_approval: 3}

  def to_s
    self.voucher
  end

  def self.pending_for_audit
    where(status: [:posted, :pending])
    .where(audit: [:for_audit, :pending_audit, :approved])
    .where.not(post_date: nil)
    .order(created_at: :desc)
  end

  def global_payable
    self.payable.to_global_id if self.payable.present?
  end

  def global_payable=(payable)
    self.payable = GlobalID::Locator.locate payable
  end
end
