class Accounting::Voucher < ApplicationRecord
  validates_presence_of :date_voucher, :particulars, :voucher, :payable_type, :payable_id,
                        :particulars, :status, :audit, :accountant_id, :type, :branch, :global_payable, :amount

  belongs_to :payable, polymorphic: true
  belongs_to :voucher_request, class_name: "Accounting::VoucherRequest", foreign_key: :request_id, optional: true
  belongs_to :treasury_account, class_name: "Treasury::Account", foreign_key: :treasury_account_id, optional: true

  has_many :general_ledgers, as: :ledgerable
  has_many :remarks, as: :remarkable, dependent: :destroy

  enum audit: { for_audit: 0, approved: 1, pending_audit: 2 }
  enum status: { pending: 0, posted: 1, cancelled: 2, for_approval: 3}

  scope :checks, -> { where(type: "Accounting::Check") }
  scope :journals, -> { where(type: "Accounting::Journal") }
  scope :debit_advices, -> { where(type: "Accounting::DebitAdvice") }


  def to_s
    self.voucher
  end

  def self.pending_for_audit
    where.not(type: 'Accounting::Journal')
    .where.not(post_date: nil)
    .where(status: [:posted, :pending])
    .order(created_at: :desc)
  end

  def global_payable
    self.payable.to_global_id if self.payable.present?
  end

  def global_payable=(payable)
    self.payable = GlobalID::Locator.locate payable
  end
end
