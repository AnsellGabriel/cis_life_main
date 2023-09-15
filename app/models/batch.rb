class Batch < ApplicationRecord
  # self.abstract_class = true
  self.table_name = "batches"

  include Calculate
  attr_accessor :rank

  validates_presence_of :effectivity_date, :expiry_date, :premium, :coop_sf_amount, :age, :agent_sf_amount, :coop_member_id
  # batch.status
  enum status: {
    recent: 0,
    renewal: 1,
    transferred: 2,
    reinstated: 3,
    for_reconsideration: 4,
    reloan: 5
  }

  # batch.insurance_status
  enum insurance_status: {
    approved: 0,
    denied: 1,
    pending: 2,
    for_review: 3,
    terminated: 4
  }

  scope :filter_by_member_name, ->(name) {
    joins(coop_member: :member)
      .where("members.first_name LIKE :name OR members.last_name LIKE :name", name: "%#{name}%")
  }
  scope :coop_member, -> { joins(:member).where('members.coop_member = ?', true) }
  scope :approved, -> { where(insurance_status: :approved) }

  belongs_to :coop_member
  belongs_to :member, optional: true
  belongs_to :agreement_benefit, optional: true

  has_many :batch_group_remits
  has_many :group_remits, through: :batch_group_remits
  has_many :batch_health_decs, as: :healthdecable, dependent: :destroy
  alias_attribute :health_declaration, :batch_health_decs
  has_many :batch_dependents, dependent: :destroy
  has_many :member_dependents, through: :batch_dependents
  has_many :batch_beneficiaries, dependent: :destroy
  has_many :member_dependents, through: :batch_beneficiaries
  has_many :batch_remarks, as: :remarkable, dependent: :destroy
  alias_attribute :remarks, :batch_remarks
  has_many :process_claims, as: :claimable, dependent: :destroy
  has_many :claim_coverages, as: :coverageable, dependent: :destroy

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
    existing_coverages = agreement.agreements_coop_members.find_by(coop_member_id: coop_member.id)
    batch.age = batch.member_details.age
    batch.expiry_date = group_remit.expiry_date
    batch.effectivity_date = ['single', 'multiple'].include?(agreement.anniversary_type) ? Date.today : group_remit.effectivity_date

    check_plan(agreement, batch, rank, duration, group_remit)

    if existing_coverages.present?
      update_batch_and_existing_coverage(batch, existing_coverages, group_remit)
    else
      create_new_batch_coverage(agreement, coop_member, batch )
    end

  end


  def self.check_plan(agreement, batch, rank, duration, group_remit)
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

  def self.update_batch_and_existing_coverage(batch, existing_coverages, group_remit)
    coverage_expiry = existing_coverages.expiry
    today = Date.today

    month_difference = ((today.year * 12 + today.month) - (coverage_expiry.year * 12 + coverage_expiry.month)) + (coverage_expiry.day > today.day ? 1 : 0)

    if month_difference > 24
      batch.status = :reinstated
      existing_coverages.update!(
        status: 'reinstated',
        expiry: batch.expiry_date,
        effectivity: batch.effectivity_date
      )
    elsif group_remit.for_renewal? || existing_coverages.expiry <= Date.today
      batch.status = :renewal
      existing_coverages.update!(
        status: 'renewal',
        expiry: batch.expiry_date,
        effectivity: batch.effectivity_date
      )
    else
      batch.status = :recent
      existing_coverages.update!(
        status: 'new',
        expiry: batch.expiry_date,
        effectivity: batch.effectivity_date
      )
    end
  end

  def self.create_new_batch_coverage(agreement, coop_member, batch )
    if agreement.transferred_date.present? && (agreement.transferred_date >= coop_member.membership_date)
      batch.status = :transferred
    else
      batch.status = :recent
    end

    agreement.agreements_coop_members.create!(
      coop_member_id: coop_member.id,
      status: 'new',
      expiry: batch.expiry_date,
      effectivity: batch.effectivity_date
    )
  end

  def new_status?
    self.status == "recent"
  end

  def accept_insurance
    self.insurance_status = :approved

    if self.previous_effectivity_date.nil? || self.previous_effectivity_date.empty?
      self.status = :recent
    else
      self.status = :renewal
    end
  end
end
