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
  
  has_one :batch_health_dec, dependent: :destroy
  
  has_many :batch_dependents, dependent: :destroy
  has_many :member_dependents, through: :batch_dependents

  has_many :batch_beneficiaries, dependent: :destroy
  has_many :member_dependents, through: :batch_beneficiaries

  def member_details
    self.coop_member.member
  end

  def dependent_ids
    self.batch_dependents.pluck(:member_dependent_id)
  end

  def beneficiary_ids
    self.batch_beneficiaries.pluck(:member_dependent_id)
  end

  def dependents_premium
    self.batch_dependents.sum(:premium)
  end

  def set_premium_and_service_fees(insured_type)
    gr = self.group_remit
    terms = self.group_remit.terms

    self.agreement_benefit_id = gr.agreement.agreement_benefits.find_by(insured_type: insured_type).id
    self.premium = ((gr.set_premium(insured_type) / 12.to_d) * terms) 
    self.coop_sf_amount = (gr.get_coop_sf/100.to_d) * self.premium
    self.agent_sf_amount = (gr.get_agent_sf/100.to_d) * self.premium
  end
end
