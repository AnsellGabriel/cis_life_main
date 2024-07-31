class Branch < ApplicationRecord
  has_many :cashier_entries, class_name: 'Treasury::CashierEntry'
  has_many :vouchers, class_name: 'Accounting::Voucher'
  has_many :employees
end
