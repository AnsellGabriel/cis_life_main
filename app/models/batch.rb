class Batch < ApplicationRecord
  self.table_name = "batches"

  include Calculate

  attr_accessor :rank, :encoded_premium

  validates_presence_of :effectivity_date, :expiry_date, :premium, :coop_sf_amount, :age, :agent_sf_amount, :coop_member_id
  # batch.status
  enum status: {
    recent: 0,
    renewal: 1,
    transferred: 2,
    reinstated: 3,
    for_reconsideration: 4,
    reloan: 5,
    terminated: 6,
    expired: 7
  }

  # batch.insurance_status
  enum insurance_status: {
    approved: 0,
    denied: 1,
    pending: 2,
    for_review: 3,
    md_recom: 4
  }

  scope :filter_by_member_name, ->(name) {
    joins(coop_member: :member)
      .where("members.first_name LIKE :name OR members.last_name LIKE :name", name: "%#{name}%")
  }
  scope :coop_member, -> { joins(:member).where("members.coop_member = ?", true) }
  # scope :approved, -> { where(insurance_status: :approved) }

  belongs_to :coop_member
  belongs_to :member, optional: true
  belongs_to :agreement_benefit, optional: true, counter_cache: true

  has_many :batch_group_remits
  has_many :group_remits, through: :batch_group_remits
  has_many :batch_health_decs, as: :healthdecable, dependent: :destroy
  has_many :batch_dependents, dependent: :destroy
  has_many :member_dependents, through: :batch_dependents
  has_many :batch_beneficiaries, dependent: :destroy
  has_many :member_dependents, through: :batch_beneficiaries
  # has_many :batch_remarks, source: :remarkable, source_type: "Batch", dependent: :destroy
  has_many :batch_remarks, as: :remarkable, dependent: :destroy
  # has_many :process_claims, as: :claimable, class_name: "Claims::ProcessClaim",  dependent: :destroy
  # has_many :claim_coverages, as: :coverageable, class_name: 'Claims::ClaimCoverage', dependent: :destroy
  has_many :reserve_batches, as: :batchable, dependent: :destroy, class_name: "Actuarial::ReserveBatch"
  has_many :adjusted_coverages, as: :coverageable, dependent: :destroy

  alias_attribute :health_declaration, :batch_health_decs
  alias_attribute :remarks, :batch_remarks

  # alias_attribute :batches, :reserve_batches

  def full_name
    "#{self.last_name}, #{self.first_name} #{self.middle_name}"
    # "#{self.coop_member.member.last_name}, #{self.coop_member.member.first_name} #{self.coop_member.member.middle_name}"
  end

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

  def dependents_manual_premium
    batch_dependents.sum(:manual_premium)
  end

  def get_group_remit
    case self.class.name
    when "Batch"
      self.group_remits.find_by(type: "Remittance")
    else
      self.group_remit
    end
  end

  def get_terms
    (self.expiry_date - self.effectivity_date).to_i / 30
  end

  def self.get_member_gyrt_coverages(member)
    joins(coop_member: :member).where(member: { id: member.id })
  end

  def self.get_reserves(date)
    joins(coop_member: :member).where(expiry_date: date.., insurance_status: :approved)
  end

  def self.get_gyrt_encoded(user_id)
    includes(group_remits: {agreement: :plan}).where(plan: {id: [1,3,4]}).where(group_remits: {mis_user: user_id}).count
  end


  def self.process_batch(batch, group_remit, rank = nil, premium = nil)
    agreement = group_remit.agreement
    coop_member = batch.coop_member
    previous_coverage = agreement.agreements_coop_members.find_by(coop_member_id: coop_member.id)
    batch.terms = group_remit.terms
    batch.expiry_date = group_remit.expiry_date
    batch.effectivity_date = ["single", "multiple"].include?(agreement.anniversary_type.downcase) ? Date.today : group_remit.effectivity_date
    batch.first_name = coop_member.member.first_name
    batch.middle_name = coop_member.member&.middle_name
    batch.last_name = "#{coop_member.member.last_name}#{coop_member.member.suffix.present? ? " #{coop_member.member.suffix}" : ""}"
    batch.birthdate = coop_member.member.birth_date
    batch.civil_status = coop_member.member.civil_status
    batch.age = batch.member_details.age(batch.effectivity_date)
    # if agreement.plan.acronym == "SII"
    #   check_plan(agreement, batch, rank, group_remit, premium, savings_amount)
    # else
    check_plan(agreement, batch, rank, group_remit, premium)
    # end

    if previous_coverage.present?
      month_difference = expiry_and_today_month_diff(previous_coverage.expiry)

      if month_difference > 24
        batch.status = :reinstated
      elsif group_remit.for_renewal? || previous_coverage.expiry <= Date.today
        batch.status = :renewal
      else
        batch.status = :recent
      end

    else
      # remove transferred date validation because membership date is not required anymore
      # if agreement.transferred_date.present? && (agreement.transferred_date >= coop_member.membership_date)
      #   batch.status = :transferred
      # else
      #   batch.status = :recent
      # end

      batch.status = :recent
    end

  end

  def self.check_plan(agreement, batch, rank, group_remit, premium)
    acronym = agreement.plan.acronym

    case acronym
    when "GYRT", "GYRTF"
      batch.set_premium_and_service_fees(:principal, group_remit, premium) # model/concerns/calculate.rb
    when "GYRTBR", "GYRTFR"
      batch.set_premium_and_service_fees(rank, group_remit, premium) # Determine premium based on rank and batch
    when "GBLISS", "SIP"
      batch.set_premium_and_service_fees(:principal, group_remit, premium) # GBLISS Plan
    when "KOOPamilya"
      batch.set_premium_and_service_fees(rank, group_remit, premium)
    # when "SII"
    #   batch.set_premium_and_service_fees(:principal, group_remit, premium, savings_amount)
    end

    # batch.valid_health_dec = true
  end

  # def self.determine_premium(rank, batch, group_remit)
  #   batch.set_premium_and_service_fees(rank, group_remit, premium)
  # end

  def self.expiry_and_today_month_diff(expiry_date)
    today = Date.today

    month_difference = ((today.year * 12 + today.month) - (expiry_date.year * 12 + expiry_date.month)) + (expiry_date.day > today.day ? 1 : 0)
  end

  def self.get_pending_gyrt(group_remits)
    joins(group_remits: :batch_group_remits).where(batch_group_remits: { group_remit:  group_remits}).where(insurance_status: :pending)
  end


  private

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
