class Accounting::Voucher < ApplicationRecord
  belongs_to :payable, polymorphic: true
  belongs_to :treasury_account
end
