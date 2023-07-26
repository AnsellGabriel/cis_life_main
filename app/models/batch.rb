class Batch < ApplicationRecord
  include Calculate
  attr_accessor :rank

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

  scope :filter_by_member_name, ->(name) {
    joins(coop_member: :member)
      .where("members.first_name LIKE :name OR members.last_name LIKE :name", name: "%#{name}%")
  }
  scope :coop_member, -> { joins(:member).where('members.coop_member = ?', true) }

  belongs_to :coop_member
  belongs_to :member, optional: true
  belongs_to :agreement_benefit

  has_many :batch_group_remits
  has_many :group_remits, through: :batch_group_remits
  has_many :batch_health_decs, dependent: :destroy
  has_many :batch_dependents, dependent: :destroy
  has_many :member_dependents, through: :batch_dependents
  has_many :batch_beneficiaries, dependent: :destroy
  has_many :member_dependents, through: :batch_beneficiaries
  has_many :batch_remarks
  has_many :process_claims, as: :claimable, dependent: :destroy


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


  def self.process_batch(batch, group_remit, rank = nil, duration = nil)
    agreement = group_remit.agreement
    coop_member = batch.coop_member
    renewal_member = agreement.agreements_coop_members.find_by(coop_member_id: coop_member.id)

    batch.age = batch.member_details.age
    batch.effectivity_date = agreement.anniversary_type == 'single' ? Date.today : group_remit.effectivity_date
    batch.expiry_date = group_remit.expiry_date

    check_plan(agreement, batch, rank, duration)

    if renewal_member.present?
        batch.status = :renewal
        renewal_member.update!(status: 'renewal')
    else
      if agreement.transferred_date >= coop_member.membership_date
        batch.status = :transferred
      else
        batch.status = :recent
      end
      agreement.agreements_coop_members.create!(coop_member_id: coop_member.id, status: 'new')
    end

  end


  def self.check_plan(agreement, batch, rank, duration)
    group_remit = agreement.group_remits.find_by(type: 'Remittance')
    acronym = agreement.plan.acronym

    case acronym
    when 'GYRT', 'GYRTF'
      batch.set_premium_and_service_fees(:principal, group_remit) # model/concerns/calculate.rb
    when 'GYRTBR', 'GYRTFR'
      determine_premium(rank, batch, group_remit) # Determine premium based on rank and batch
    when 'PMFC'
      batch.residency = (Date.today.year * 12 + Date.today.month) - (batch.coop_member.membership_date.year * 12 + batch.coop_member.membership_date.month)
      batch.duration = duration
      batch.set_premium_and_service_fees(:principal, group_remit, true) # model/concerns/calculate.rb
    end

  end


  def self.determine_premium(rank, batch, group_remit)
    batch.set_premium_and_service_fees(rank, group_remit)
  end


  private

  def new_status?
    self.status == "recent"
  end



  # def delete_agreements_coop_members
  #   agreement = self.group_remits[0].agreement
  #   coop_member = self.coop_member
  #   agreement.coop_members.delete(coop_member)
  #   self.batch_group_remits.destroy_all
  # end

  # def unique_coop_member_in_anniversary
  #   if coop_member.present? && group_remit.agreement.group_remits.joins(:anniversary, batches: :coop_member)
  #           .where('coop_members.id': coop_member_id)
  #           .where.not(group_remits: { id: group_remit_id })
  #           .where.not(anniversaries: { id: group_remit.anniversary_id })
  #           .exists?

  #     errors.add(:coop_member_id, "already exists in another batch with a different anniversary")
  #   end
  # end

end
