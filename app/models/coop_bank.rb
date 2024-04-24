class CoopBank < ApplicationRecord
  # validates_presence_of :cooperative_id, :treasury_account_id
  # validates :account_number, presence: true, format: { with: /\A\d+\z/, message: "must be digits only" }

  belongs_to :cooperative
  belongs_to :treasury_account, class_name: 'Treasury::Account'
end
