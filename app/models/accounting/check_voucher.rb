class Accounting::CheckVoucher < ApplicationRecord
  belongs_to :payable, polymorphic: true
end
