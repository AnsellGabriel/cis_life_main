class Batch < ApplicationRecord
  validate :unique_coop_member_in_anniversary, if: -> { group_remit.present? }

  include Calculate
  attr_accessor :rank

  # remove association of coop_member from agreement.coop_members
  # if batch is destroyed and status is new/recent
  before_destroy :delete_agreements_coop_members, if: :new_status?

  scope :filter_by_member_name, ->(name) {
    joins(coop_member: :member)
      .where("members.first_name LIKE :name OR members.last_name LIKE :name", name: "%#{name}%")
  }
  
  # validates_presence_of :effectivity_date, :expiry_date, :coop_sf_amount, :agent_sf_amount, :status, :premium, :coop_member_id

  # updates the batches table realtime when a new batch is created
  after_create_commit -> { broadcast_prepend_to [ coop_member.cooperative, "batches" ], locals: { group_remit: self.group_remit, agreement: self.group_remit.agreement }, target: "batches_body" }
  # updates the batches table realtime when a batch is updated
  # after_update_commit -> { broadcast_replace_to [ coop_member.cooperative, "batches" ], locals: { group_remit: self.group_remit }, target: self }
  # updates the batches table realtime when a batch is destroyed
  after_destroy_commit -> { broadcast_remove_to [ coop_member.cooperative, "batches" ], target: self }

  # batch.status
  enum status: {
    recent: 0,
    renewal: 1,
    transferred: 2,
    reinstated: 3
  }

  # batch.insurance_status
  enum insurance_status: {
    approved: 0,
    denied: 1,
    pending: 2,
    for_review: 3
  }

  belongs_to :coop_member
  belongs_to :member, optional: true
  scope :coop_member, -> { joins(:member).where('members.coop_member = ?', true) }

  belongs_to :group_remit
  belongs_to :agreement_benefit
  
  has_many :batch_health_decs, dependent: :destroy
  has_many :batch_dependents, dependent: :destroy
  has_many :member_dependents, through: :batch_dependents
  has_many :batch_beneficiaries, dependent: :destroy
  has_many :member_dependents, through: :batch_beneficiaries
  has_many :batch_remarks
  has_many :process_claims, dependent: :destroy

  def update_valid_health_dec
    self.update_attribute(:valid_health_dec, true)
    self.save!
  end

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

  def self.process_batch(batch, group_remit, rank = nil, transferred = false, duration = nil)
    agreement = group_remit.agreement
    coop_member = batch.coop_member
    renewal_member = agreement.agreements_coop_members.find_by(coop_member_id: coop_member.id)
    batch.age = batch.member_details.age

    if agreement.anniversary_type == 'none'
      batch.effectivity_date = Date.today.beginning_of_month
      batch.expiry_date = Date.today.next_year.prev_month.end_of_month
    end

    check_plan(agreement, batch, rank, duration)

    if renewal_member.present?
        batch.status = :renewal
        renewal_member.update!(status: 'renewal')
    else
      if transferred == true || transferred == "1"
        batch.status = :transferred
      else
        batch.status = :recent
      end
      agreement.agreements_coop_members.create!(coop_member_id: coop_member.id, status: 'new')
    end

  end

  def self.check_plan(agreement, batch, rank, duration)
    if agreement.plan.acronym == 'GYRT' || agreement.plan.acronym == 'GYRTF'
      # batch.set_premium_and_service_fees(:principal, batch.group_remit) # model/concerns/calculate.rb
      batch.set_premium_and_service_fees(:principal, batch.group_remit) # model/concerns/calculate.rb
    elsif agreement.plan.acronym == 'GYRTBR' || agreement.plan.acronym == 'GYRTFR'
      self.determine_premium(rank, batch, batch.group_remit)
    elsif agreement.plan.acronym == 'PMFC'
      batch.residency = (Date.today.year * 12 + Date.today.month) - (batch.coop_member.membership_date.year * 12 + batch.coop_member.membership_date.month)
      batch.duration = duration
      batch.set_premium_and_service_fees(:principal, batch.group_remit, true) # model/concerns/calculate.rb
    end
    
  end

  # def set_duration_and_residency
  # end

  def self.determine_premium(rank, batch, group_remit)
    # case rank
    # when 'BOD'
    #   batch.set_premium_and_service_fees(:ranking_bod, group_remit)
    # when 'SO'
    #   batch.set_premium_and_service_fees(:ranking_senior_officer, group_remit)
    # when 'JO'
    #   batch.set_premium_and_service_fees(:ranking_junior_officer, group_remit)
    # when 'RF'
    #   batch.set_premium_and_service_fees(:ranking_rank_and_file, group_remit)
    # end
    batch.set_premium_and_service_fees(rank, group_remit)
  end

  private

  def new_status?
    self.status == "recent"
  end

  def delete_agreements_coop_members
    agreement = self.group_remit.agreement
    coop_member = self.coop_member

    agreement.coop_members.delete(coop_member)
  end

  def unique_coop_member_in_anniversary
    if coop_member.present? && group_remit.agreement.group_remits.joins(:anniversary, batches: :coop_member)
            .where('coop_members.id': coop_member_id)
            .where.not(group_remits: { id: group_remit_id })
            .where.not(anniversaries: { id: group_remit.anniversary_id })
            .exists?

      errors.add(:coop_member_id, "already exists in another batch with a different anniversary")
    end
  end

end
