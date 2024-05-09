class CoopBank < ApplicationRecord
  validates_presence_of :cooperative_id, :treasury_account_id
  validates :cooperative_id, uniqueness: { scope: :treasury_account_id }

  belongs_to :cooperative
  belongs_to :treasury_account, class_name: 'Treasury::Account'
end
