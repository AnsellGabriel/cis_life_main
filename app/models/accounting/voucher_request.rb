class Accounting::VoucherRequest < ApplicationRecord
  belongs_to :request, polymorphic: true
  belongs_to :voucher, polymorphic: true

  enum status: {
    pending: 0,
    voucher_generated: 1,
    posted: 2,
    cancelled: 3
  }
end
