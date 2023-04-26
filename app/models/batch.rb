class Batch < ApplicationRecord
  # validates_presence_of :effectivity_date, :expiry_date, :coop_sf_amount, :agent_sf_amount, :status, :premium, :coop_member_id

  enum status: {
    recent: 0,
    renewal: 1,
    transferred: 2
  }

  enum insurance_status: {
    approved: 0,
    denied: 1,
    pending: 2
  }

  belongs_to :coop_member
  belongs_to :group_remit
  belongs_to :agreement_benefit
  
  has_many :batch_dependents, dependent: :destroy
  accepts_nested_attributes_for :batch_dependents
end
