class Accounting::CheckVoucher < ApplicationRecord
  validates_presence_of :date_voucher, :voucher, :payable_id, :payable_type, :amount, :particulars

  belongs_to :payable, polymorphic: true
end
