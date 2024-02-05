class Accounting::CheckVoucherRequest < ApplicationRecord
  belongs_to :requestable, polymorphic: true
  has_many :check_vouchers, class_name: "Accounting::Check"
  self.table_name = "check_voucher_requests"

  enum status: {
    pending: 0,
    voucher_generated: 1,
    denied: 2
  }
end
