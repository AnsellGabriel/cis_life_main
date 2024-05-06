class Accounting::DebitAdviceJournal < ApplicationRecord
  belongs_to :debit_advice, class_name: "Accounting::DebitAdvice"
  belongs_to :journal_voucher, class_name: "Accounting::Journal"
end
