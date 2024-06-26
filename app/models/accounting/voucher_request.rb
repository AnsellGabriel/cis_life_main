class Accounting::VoucherRequest < ApplicationRecord
  self.table_name = "voucher_requests"

  belongs_to :requestable, polymorphic: true
  belongs_to :account, class_name: "Treasury::Account", optional: true
  has_many :vouchers, class_name: "Accounting::Voucher", foreign_key: :request_id, dependent: :destroy
  has_many :remarks, as: :remarkable, dependent: :destroy

  enum status: {
    pending: 0,
    voucher_generated: 1,
    rejected: 2,
    posted: 3
  }

  enum payment_type: {
    check_voucher: 0,
    debit_advice: 1,
    journal_voucher: 2
  }

  enum request_type: {
    claims_payment: 0,
    refund: 1,
    request: 2
  }

  def entry_type
    'request'
  end

  def payee
    case requestable
    when Claims::ProcessClaim
      requestable.cooperative
    when Accounting::DebitAdvice
      requestable.payable
    end
  end
end
