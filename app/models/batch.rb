class Batch < ApplicationRecord
  attr_accessor :rank
  # validates_presence_of :effectivity_date, :expiry_date, :coop_sf_amount, :agent_sf_amount, :status, :premium, :coop_member_id

  # updates the batches table realtime when a new batch is created
  after_create_commit -> { broadcast_prepend_to [ coop_member.cooperative, "batches" ], locals: { group_remit: self.group_remit, agreement: self.group_remit.agreement }, target: "batches_body" }
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
  belongs_to :agreement_benefit
  
  has_one :batch_health_dec, dependent: :destroy
  has_many :batch_dependents, dependent: :destroy
  has_many :member_dependents, through: :batch_dependents
  has_many :batch_beneficiaries, dependent: :destroy
  has_many :member_dependents, through: :batch_beneficiaries

  def member_details
    coop_member.member
  end

  def dependent_ids
    batch_dependents.pluck(:member_dependent_id)
  end

  def beneficiary_ids
    batch_beneficiaries.pluck(:member_dependent_id)
  end

  def dependents_premium
    batch_dependents.sum(:premium)
  end

  def get_premium
    agreement_benefit.product_benefits.sum(:premium)
  end

  def set_premium_and_service_fees(insured_type)
    gr = self.group_remit
    terms = self.group_remit.terms
    agreement_benefit = gr.agreement.agreement_benefits.find_by(insured_type: insured_type)

    self.agreement_benefit_id = agreement_benefit.id
    self.premium = ((self.get_premium / 12.to_d) * terms) 
    self.coop_sf_amount = (gr.get_coop_sf/100.to_d) * self.premium
    self.agent_sf_amount = (gr.get_agent_sf/100.to_d) * self.premium
  end

  def self.process_batch(batch, member, group_remit, rank = nil, transferred = false)
    agreement = group_remit.agreement
    coop_member = batch.coop_member
    renewal_member = agreement.coop_members.find_by(id: coop_member.id)
    
    if renewal_member.present?
        batch.status = :renewal
    else
      if transferred == true || transferred == "1"
        batch.status = :renewal
      else
        batch.status = :recent
      end
      agreement.coop_members << coop_member
    end

    check_plan(agreement, batch, rank)
  end

  def self.check_plan(agreement, batch, rank)
    if agreement.plan.acronym == 'GYRT' || agreement.plan.acronym == 'GYRTF'
      batch.set_premium_and_service_fees(:principal)
    elsif agreement.plan.acronym == 'GYRTBR' || agreement.plan.acronym == 'GYRTFR'
      self.determine_premium(rank, batch)
    end
  end

  def self.determine_premium(rank, batch)
    case rank
    when 'BOD'
      batch.set_premium_and_service_fees(:ranking_bod)
    when 'SO'
      batch.set_premium_and_service_fees(:ranking_senior_officer)
    when 'JO'
      batch.set_premium_and_service_fees(:ranking_junior_officer)
    when 'RF'
      batch.set_premium_and_service_fees(:ranking_rank_and_file)
    end
  end
end
