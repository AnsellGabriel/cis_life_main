class Batch < ApplicationRecord
  validates_presence_of :effectivity_date, :expiry_date, :active, :coop_sf_amount, :agent_sf_amount, :status, :premium, :coop_member_id

  enum status: {
    recent: 0,
    renewal: 1,
    transferred: 2
  }
  # belongs_to :group_remit

  belongs_to :coop_member
  belongs_to :group_remit
  
  has_many :batch_dependents, dependent: :destroy
  accepts_nested_attributes_for :batch_dependents
end
