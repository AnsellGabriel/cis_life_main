class Accounting::JournalVoucherRequest < ApplicationRecord
  self.table_name = "journal_voucher_requests"

  validates_presence_of :requestable, :amount, :status, :particulars

  belongs_to :requestable, polymorphic: true
  has_many :debit_advices, class_name: "Accounting::DebitAdvice"
  has_many :vouchers, as: :requestable, class_name: "Accounting::Voucher"

  enum status: {
    pending: 0,
    voucher_generated: 1,
    denied: 2,
    posted: 3
  }

  enum request_type: {
    debit_advice: 0
  }
end
