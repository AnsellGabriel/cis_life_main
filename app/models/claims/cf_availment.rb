class Claims::CfAvailment < ApplicationRecord
  belongs_to :process_claim
  belongs_to :cf_account
  belongs_to :user
  has_many :cf_ledgers, as: :ledgerable, class_name: "Claims::CfLedger"

  enum status: {
    pending: 0,
    approved_head: 1,
    denied: 2,
    approved_final: 3
  }
end
