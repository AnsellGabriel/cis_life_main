class GeneralLedger < ApplicationRecord
  validates_presence_of :ledger_type, :account_id, :amount, :description

  belongs_to :ledgerable, polymorphic: true
  belongs_to :account, class_name: "Treasury::Account", foreign_key: "account_id"

  enum ledger_type: { debit: 0, credit: 1 }

  scope :debits , -> { where(ledger_type: 0) }
  scope :credits, -> { where(ledger_type: 1) }

  def self.total_debit
    debits.sum(:amount)
  end

  def self.total_credit
    credits.sum(:amount)
  end
end
