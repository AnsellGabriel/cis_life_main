class Accounting::CheckVoucherRequest < ApplicationRecord
  validates_presence_of :requestable_type, :requestable_id, :amount, :status, :analyst, :description, :payment_type, :payout_type
  validates_presence_of :bank_id, if: :debit_advice?

  self.table_name = "check_voucher_requests"

  belongs_to :requestable, polymorphic: true
  belongs_to :check_voucher_request, optional: true
  has_many :vouchers, as: :requestable, class_name: "Accounting::Voucher"

  enum status: {
    pending: 0,
    voucher_generated: 1,
    denied: 2,
    posted: 3
  }

  enum payment_type: {
    claims_payment: 0,
    refund: 1
  }

  enum request_type: {
    check_voucher: 0,
    debit_advice: 1,
    journal_voucher: 2
  }

end
