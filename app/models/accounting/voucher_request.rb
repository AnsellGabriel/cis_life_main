class Accounting::VoucherRequest < ApplicationRecord
  self.table_name = "voucher_requests"

  belongs_to :requestable, polymorphic: true
  belongs_to :account, class_name: "Treasury::Account", optional: true
  has_many :vouchers, class_name: "Accounting::Voucher", foreign_key: :request_id, dependent: :destroy

  enum status: {
    pending: 0,
    voucher_generated: 1,
    cancelled: 2,
    posted: 3
  }

  enum payment_type: {
    check_voucher: 0,
    debit_advice: 1,
    journal_voucher: 2
  }

  enum request_type: {
    claims_payment: 0,
    refund: 1
  }
end
