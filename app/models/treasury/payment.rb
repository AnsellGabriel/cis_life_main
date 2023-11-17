class Treasury::Payment < ApplicationRecord
  validates_presence_of :payment_type, :amount, :account_id

  belongs_to :account
  belongs_to :cashier_entry

  enum payment_type: { cash: 1, check: 2 }
end
