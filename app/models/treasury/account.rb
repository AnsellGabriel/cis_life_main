class Treasury::Account < ApplicationRecord
  enum account_type: {
    assets: 1,
    liability: 2,
    member_equity: 3,
    income: 4,
    expense: 5
  }

  has_many :check_vouchers, class_name: 'Accounting::CheckVoucher'
  has_many :cashier_entries, class_name: 'Treasury::CashierEntry'

  def to_s
    name
  end
end
