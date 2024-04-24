class Accounting::CheckVoucherRequest < ApplicationRecord
  self.table_name = "check_voucher_requests"

  belongs_to :requestable, polymorphic: true
  belongs_to :check_voucher_request, optional: true
  has_many :check_vouchers, class_name: "Accounting::Check"
  has_many :debit_advices, class_name: "Accounting::DebitAdvice"


  enum status: {
    pending: 0,
    voucher_generated: 1,
    denied: 2
  }

  enum payment_type: {
    claims_payment: 0,
    refund: 1
  }

  enum payout_type: {
    check_voucher: 0,
    debit_advice: 1
  }

end
