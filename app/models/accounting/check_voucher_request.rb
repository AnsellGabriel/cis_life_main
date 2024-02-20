class Accounting::CheckVoucherRequest < ApplicationRecord
  self.table_name = "check_voucher_requests"

  belongs_to :requestable, polymorphic: true
  has_many :check_vouchers, class_name: "Accounting::Check"

  enum status: {
    pending: 0,
    voucher_generated: 1,
    denied: 2
  }

  enum payment_type: {
    claims_payment: 0,
    refund: 1
  }

end
