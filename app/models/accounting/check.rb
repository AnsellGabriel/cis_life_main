class Accounting::Check < ApplicationRecord
  validates_presence_of :treasury_account_id, :amount

  belongs_to :account, class_name: "Accounting::Account", foreign_key: "treasury_account_id"
end
