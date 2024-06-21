class Claims::CfReplenish < ApplicationRecord
  belongs_to :cf_account
  belongs_to :user
  has_many :cf_ledgers, as: :ledgerable

  enum status: {
    pending: 0,
    approved: 1,
    denied: 2
  }
end
