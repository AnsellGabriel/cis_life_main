class ClaimRequestForPayment < ApplicationRecord
  belongs_to :process_claim
  has_many :check_vouchers, class_name: "Accounting::Check"

  enum status: {
    pending: 0,
    voucher_generated: 1,
    denied: 2
  }
end
