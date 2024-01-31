class CheckVoucherRequest < ApplicationRecord
  belongs_to :requestable, polymorphic: true
  has_many :check_vouchers, class_name: "Accounting::Check"

  enum status: {
    pending: 0,
    voucher_generated: 1,
    denied: 2
  }
end
