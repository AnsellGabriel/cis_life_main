class Remark < ApplicationRecord
  validates_presence_of :remark, :remarkable_id, :remarkable_type

  belongs_to :remarkable, polymorphic: true
  belongs_to :user

  enum category: {
    incorrect_voucher_details: 0,
    incorrect_claim_details: 1
  }
end
