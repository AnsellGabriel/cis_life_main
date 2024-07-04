class Accounting::AccountBeginningBalance < ApplicationRecord
  self.table_name = 'accounts_beginning_balances'

  belongs_to :account, class_name: "Treasury::Account"
end
