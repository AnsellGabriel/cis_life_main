class Accounting::DebitAdviceReceipt < ApplicationRecord
  self.table_name = 'debit_advice_receipts'

  mount_uploader :receipt, ReceiptUploader

  belongs_to :debit_advice, class_name: 'Accounting::DebitAdvice', optional: true
end
