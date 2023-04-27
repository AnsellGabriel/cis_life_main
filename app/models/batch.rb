class Batch < ApplicationRecord
  # validates_presence_of :effectivity_date, :expiry_date, :coop_sf_amount, :agent_sf_amount, :status, :premium, :coop_member_id
  after_create_commit -> { broadcast_prepend_to "batches", partial: "batches/batch", locals: { batch: self, group_remit: self.group_remit }, target: "batches_body" }

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
  
  has_many :batch_dependents, dependent: :destroy
  accepts_nested_attributes_for :batch_dependents
end
