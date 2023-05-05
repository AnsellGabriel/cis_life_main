class Batch < ApplicationRecord
  # validates_presence_of :effectivity_date, :expiry_date, :coop_sf_amount, :agent_sf_amount, :status, :premium, :coop_member_id

  # updates the batches table realtime when a new batch is created
  after_create_commit -> { broadcast_prepend_to [ coop_member.cooperative, "batches" ], locals: { group_remit: self.group_remit }, target: "batches_body" }
  # updates the batches table realtime when a batch is updated
  after_update_commit -> { broadcast_replace_to [ coop_member.cooperative, "batches" ], locals: { group_remit: self.group_remit }, target: self }
  # updates the batches table realtime when a batch is destroyed
  after_destroy_commit -> { broadcast_remove_to [ coop_member.cooperative, "batches" ], target: self }

  # batch.status
  enum status: {
    recent: 0,
    renewal: 1,
    transferred: 2
  }

  # batch.insurance_status
  enum insurance_status: {
    approved: 0,
    denied: 1,
    pending: 2
  }

  belongs_to :coop_member
  belongs_to :group_remit
  
  has_many :batch_dependents, dependent: :destroy
  has_many :member_dependents, through: :batch_dependents
end
