class Accounting::JournalVoucherRequest < ApplicationRecord
  validates_presence_of :requestable, :amount, :status, :particulars

  belongs_to :requestable, polymorphic: true
end
