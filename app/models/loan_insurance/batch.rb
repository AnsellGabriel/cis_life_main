class LoanInsurance::Batch < Batch
  attr_accessor :encoded_premium
  attr_accessor :encoded_unused

  include CoverageStatus
  self.table_name = "loan_insurance_batches"


  validate :agreement_benefit, unless: :skip_validation # skip agreement_benefit validation
  validates_presence_of :coop_member_id, :insurance_status, :loan_amount, :effectivity_date, :expiry_date

  belongs_to :group_remit, class_name: "LoanInsurance::GroupRemit", foreign_key: "group_remit_id", optional: true
  belongs_to :loan, class_name: "LoanInsurance::Loan", foreign_key: "loan_insurance_loan_id", optional: true
  belongs_to :rate, class_name: "LoanInsurance::Rate", foreign_key: "loan_insurance_rate_id", optional: true

  # belongs_to :process_claim, class_name: "Claims::ProcessClaim", optional: true
  # belongs_to :retention, class_name: 'LoanInsurance::Retention', foreign_key: 'loan_insurance_retention_id'
  has_many :details, class_name: "LoanInsurance::Detail"
  has_many :batch_health_decs, as: :healthdecable, dependent: :destroy
  # has_many :batch_remarks, source: :remarkable, source_type: "LoanInsurance::Batch", dependent: :destroy
  has_many :batch_remarks, as: :remarkable, dependent: :destroy
  has_many :reinsurance_batches
  has_many :reinsurance_members, through: :reinsurance_batches
  has_many :reinsurer_ri_batches, through: :reinsurance_batches

  has_many :reserve_batches, class_name: "Actuarial::ReserveBatch", as: :batchable, dependent: :destroy
  has_many :reserves, through: :reserve_batches, class_name: "Actuarial::Reserve"

  has_many :adjusted_coverages, as: :coverageable, dependent: :destroy

  def self.get_lppi_batches_count(user_id)
    includes(group_remit: { agreement: :plan}).where(plan: {id: 2}).where(group_remit: {mis_user: user_id}).count
  end

  def sii_skip_validation
    group_remit.agreement.plan.acronym == "SII"
  end

  def sii_process_batch
    agreement = group_remit.agreement
    sii_set_terms_and_details(agreement)
    loan_rate = find_loan_rate(agreement)
    previous_coverage = agreement.agreements_coop_members.find_by(coop_member_id: coop_member.id)
    if previous_coverage.present?
      month_difference = expiry_and_today_month_diff(previous_coverage.expiry)

      if month_difference > 24
        self.status = :reinstated
      else
        self.status = :reloan
      end

    else
      # remove transferred date validation because membership date is not required anymore
      # if agreement.transferred_date.present? && (agreement.transferred_date >= coop_member.membership_date)
      #   self.status = :transferred
      # else
      #   self.status = :recent
      # end

      self.status = :recent
    end
    if self.loan_amount <= agreement.nel
      self.valid_health_dec = true
    end

    self.premium = (loan_amount / 1000 ) * ((loan_rate.annual_rate / 12) * terms)
    self.unused = 0
    self.premium_due = premium
    self.agent_sf_amount = calculate_service_fee(loan_rate.agent_sf, premium_due)
    self.coop_sf_amount = calculate_service_fee(loan_rate.coop_sf, premium_due)
  end

  def sii_set_terms_and_details(agreement)
    anniv_date = agreement.anniversaries.first.anniversary_date
    self.effectivity_date = Date.today
    self.expiry_date = self.effectivity_date <= anniv_date ? anniv_date : anniv_date.next_year
    self.terms = compute_terms(expiry_date, effectivity_date)
    self.insurance_status = :for_review
    self.age = coop_member.age(effectivity_date)
    self.first_name = coop_member.member.first_name
    self.middle_name = coop_member.member&.middle_name
    self.last_name = coop_member.member.last_name
    self.birthdate = coop_member.member.birth_date
    self.civil_status = coop_member.member.civil_status
    self.loan = coop_member.cooperative.loans.find_by(for_sii: true)
  end

  def process_batch(encoded_premium = nil, current_user = nil, encoded_unused = nil)
    return :no_dates if effectivity_date.nil? || expiry_date.nil?

    agreement = group_remit.agreement
    set_terms_and_details
    loan_rate = find_loan_rate(agreement)
    previous_coverage = agreement.agreements_coop_members.find_by(coop_member_id: coop_member.id)

    if previous_coverage.present?
      month_difference = expiry_and_today_month_diff(previous_coverage.expiry)

      if month_difference > 24
        self.status = :reinstated
      else
        self.status = :reloan
      end

    else
      # remove transferred date validation because membership date is not required anymore
      # if agreement.transferred_date.present? && (agreement.transferred_date >= coop_member.membership_date)
      #   self.status = :transferred
      # else
      #   self.status = :recent
      # end

      self.status = :recent
    end
    # requires no health declaration if loan amount is less than or equal to agreement's nel
    if self.loan_amount <= agreement.nel
      self.valid_health_dec = true
    else
      cm = coop_member
      prev_cov = coop_member.loan_batches.order(effectivity_date: :desc).last

      self.valid_health_dec = prev_cov.present? ? prev_cov.valid_health_dec : false
    end

    if effectivity_date < Date.today
      if ((Date.today - effectivity_date).to_i / 30) >= 2 #months
        self.batch_remarks.build(remark: "The remittance is late by over 60 days as of today.",
        status: :pending,
        user: current_user.userable
        )
        self.insurance_status = :pending
      end
    end

    #! do not add code after this validation as this is the return value of the method
    #! please add them above this comment
    if self.rate.nil?
      loan_rate
    else
      calculate_values(agreement, loan_rate, encoded_premium, encoded_unused, current_user)
      true
    end
  end

  def get_terms
    terms
  end

  def get_rate_age_range
    (self.rate.min_age..self.rate.max_age).include?(self.age)
  end

  def update_prem_substandard(sub_rate)
    self.adjusted_prem = (self.loan_amount / 1000) * (sub_rate * self.terms)

    # if unused_loan_id
    #   previous_batch = LoanInsurance::Batch.find(unused_loan_id)
    #   previous_batch.update(status: :terminated, terminate_date: self.effectivity_date)
    #   unused_term = compute_terms(previous_batch.expiry_date, effectivity_date)
    #   self.unused = (previous_batch.loan_amount / 1000 ) * (rate.monthly_rate * unused_term)
    #   self.premium_due = self.premium - unused
    # else
    #   self.unused = 0
    #   self.premium_due = self.premium
    # end

    # self.agent_sf_amount = calculate_service_fee(self.group_remit.agreement.agent_sf, self.adjusted_prem)
    # self.coop_sf_amount = calculate_service_fee(self.group_remit.agreement.coop_sf, self.adjusted_prem)
  end

  def add_adjustment(rate)
    total_rate = self.rate.annual_rate * rate
    adjusted_coverage = (self.premium) / (total_rate / 12 * self.terms) * 1000
    adjusted_premium = (self.loan_amount / 1000 ) * ((total_rate / 12) * self.terms)
    underpayment = adjusted_premium - self.premium


    adjusted_coverages.build(
      substandard_rate: rate,
      total_rate: total_rate,
      adjusted_premium: adjusted_premium,
      adjusted_coverage: adjusted_coverage,
      underpayment: underpayment,
      status: :pending
    )
    # self.substandard = true
  end

  def adjustment(type, current_user, adjusted)
    case type
    when "prem"
      self.adjusted_prem = adjusted.adjusted_premium
      if unused_loan_id
        previous_batch = LoanInsurance::Batch.find(unused_loan_id)
        previous_batch.update(status: :terminated, terminate_date: self.effectivity_date)
        unused_term = compute_terms(previous_batch.expiry_date, effectivity_date)
        self.adjusted_unuse = (previous_batch.loan_amount / 1000 ) * (rate.monthly_rate * unused_term)
        self.adjusted_premium_due = self.adjusted_prem - adjusted_unuse
      else
        self.adjusted_unuse = 0
        self.adjusted_premium_due = self.adjusted_prem
      end

      self.adjusted_agent_sf = calculate_service_fee(self.rate.agent_sf, self.adjusted_prem)
      self.adjusted_coop_sf = calculate_service_fee(self.rate.coop_sf, self.adjusted_prem)

      batch_remarks.build(remark: "Adjusted premium accepted. : #{self.adjusted_prem}", status: :prem_adjust, user: current_user.userable)
    when "cov"
      self.adjusted_cov = adjusted.adjusted_coverage
      batch_remarks.build(remark: "Adjusted coverage accepted. : #{self.adjusted_cov}", status: :cov_adjust, user: current_user.userable)
    end
    # self.substandard = true
    adjusted.update!(status: :approved)
  end

  def self.get_member_lppi_coverages(member)
    joins(coop_member: :member).where(member: { id: member.id })
  end

  def self.get_reserves(start_date=nil, end_date)
    reserve_date = end_date.end_of_year
    joins(coop_member: :member).where.not(insurance_status: :denied).where(created_loan_amount: 500.., expiry_date: reserve_date..)
  end

  def check_md_reco
    self.batch_remarks.where(status: 2).count
  end

  def self.get_ri_batches(ri_period)
    where(effectivity_date: ri_period, loan_amount: 350000.., insurance_status: :approved)
    # where(effectivity_date: ri_period, loan_amount: 350000.., insurance_status: :approved)
  end

  def self.get_reserve_batches(date)
    joins(coop_member: :member).where(expiry_date: date.., insurance_status: :approved)
  end

  def get_ri_date(ri)
    self.reinsurance_batches.find_by(reinsurance: ri, batch: self).ri_date
  end

  def get_ri_eff_exp(ri, type)
    if type == "eff"
      self.reinsurance_batches.joins(:reinsurance_member).find_by(reinsurance_member: { reinsurance: ri }, batch: self).ri_effectivity
    elsif type == "exp"
      self.reinsurance_batches.joins(:reinsurance_member).find_by(reinsurance_member: { reinsurance: ri }, batch: self).ri_expiry
    elsif type == "terms"
      self.reinsurance_batches.joins(:reinsurance_member).find_by(reinsurance_member: { reinsurance: ri }, batch: self).ri_terms
    end
  end

  def get_ri_batch_id(ri)
    self.reinsurance_batches.joins(:reinsurance_member).find_by(reinsurance_member: { reinsurance: ri }, batch: self).id
  end

  def batch_dependents
    nil
  end

  def calculate_values(agreement, loan_rate, encoded_premium = nil, encoded_unused = nil, current_user = nil)
    compute_premium(encoded_premium, agreement)

    self.excess = 0 # reset excess value

    if encoded_unused and encoded_unused != 0
      self.unused = encoded_unused

      if unused_loan_id and unused_loan_id != 0
        update_prev_batch_and_return_unused_term(unused_loan_id, true)
      else
        self.batch_remarks.find_or_initialize_by(remark: "Unused loan not found. Manual review required.", user: current_user)
      end
    else
      if unused_loan_id and unused_loan_id != 0
        update_prev_batch_and_return_unused_term(unused_loan_id)
      else
        self.unused = 0
      end
    end

    self.premium_due = premium - unused

    if self.premium_due < 0
      self.excess = self.premium_due.abs
      self.premium_due = 0
    end

    # self.agent_sf_amount = calculate_service_fee(agreement.agent_sf, premium_due)
    # self.coop_sf_amount = calculate_service_fee(agreement.coop_sf, premium_due)
    if agreement.with_markup == true
      self.coop_sf_amount = calculate_service_fee((loan_rate.coop_sf + loan_rate.markup_sf), premium_due)
    else
      self.coop_sf_amount = calculate_service_fee(loan_rate.coop_sf, premium_due)
    end
    self.agent_sf_amount = calculate_service_fee(loan_rate.agent_sf, premium_due)
  end

  def compute_premium(encoded_premium, agreement)
    if encoded_premium.present? && encoded_premium != 0
      self.premium = encoded_premium
      self.system_premium = agreement.with_markup? ?  (loan_amount / 1000 ) * (rate_with_markup * terms) : (loan_amount / 1000 ) * ((rate.annual_rate / 12) * terms)
    elsif agreement.with_markup?
      rate_with_markup = (rate.annual_rate / 12) + (rate.markup_rate)
      self.premium = (loan_amount / 1000 ) * (rate_with_markup * terms) # use encoded premium by MIS if present
    else
      self.premium = (loan_amount / 1000 ) * ((rate.annual_rate / 12) * terms) # use encoded premium by MIS if present
    end
  end

  def update_prev_batch_and_return_unused_term(unused_loan_id, system_unused = false)
    previous_batch = LoanInsurance::Batch.find(unused_loan_id)
    previous_batch.update(status: :terminated, terminate_date: effectivity_date)
    unused_term = compute_terms(previous_batch.expiry_date, effectivity_date)

    if system_unused
      self.system_unused = (previous_batch.loan_amount / 1000 ) * (rate.monthly_rate * unused_term)
    else
      self.unused = (previous_batch.loan_amount / 1000 ) * (rate.monthly_rate * unused_term)
    end
  end

  def previous_loan
    unless unused_loan_id.nil? or unused_loan_id == 0
      LoanInsurance::Batch.find(unused_loan_id)
    end
  end

  def call_for_private_meth(type, agreement, percentage, premium)
    case type
    when "rate"
      find_loan_rate(agreement)
    when "sf"
      calculate_service_fee(percentage, premium)
    end
  end

  private

  def skip_validation
    true
  end

  def set_terms_and_details
    self.terms = compute_terms(expiry_date, effectivity_date)
    self.insurance_status = :for_review
    self.age = coop_member.age(effectivity_date)
    self.first_name = coop_member.member.first_name
    self.middle_name = coop_member.member&.middle_name
    self.last_name = coop_member.member.last_name
    self.birthdate = coop_member.member.birth_date
    self.civil_status = coop_member.member.civil_status
    self.date_release = effectivity_date if not self.date_release.present?
    self.date_mature = expiry_date if not self.date_mature.present?
  end

  def find_loan_rate(agreement)
    # self.rate = agreement.loan_rates.where("min_age <= ? AND max_age >= ?", age, age).where("? BETWEEN min_amount AND max_amount", loan_amount).first

    age_loan_rate = agreement.loan_rates.where("min_age <= ? AND max_age >= ?", age, age)

    if age_loan_rate.empty?
      return :no_rate_for_age
    else
      self.rate = age_loan_rate.where("? BETWEEN min_amount AND max_amount", loan_amount).first

      if self.rate.nil?
        return :no_rate_for_amount
      else
        return self.rate
      end
    end
  end





  def calculate_service_fee(service_fee_percentage, premium)
    (service_fee_percentage / 100.to_d) * premium
  end

  # def find_existing_coverages(agreement)
  #   existing_coverage = agreement.agreements_coop_members.where(coop_member_id: coop_member.id).order(created_at: :desc).first

  #   if existing_coverage
  #     update_batch_and_existing_coverage(self, existing_coverage, group_remit)
  #   else
  #     create_new_batch_coverage(agreement, coop_member, self )
  #   end
  # end

  def compute_terms(expiry_date, effectivity_date)
    # ! revert the formula to the original formula due to incorrect terms computation
    (expiry_date.year - effectivity_date.year) * 12 + (expiry_date.month - effectivity_date.month) + (expiry_date.day > effectivity_date.day ? 1 : 0)
    # ((expiry_date - effectivity_date) / 30).to_f.round
  end

  def expiry_and_today_month_diff(expiry_date)
    today = Date.today

    month_difference = ((today.year * 12 + today.month) - (expiry_date.year * 12 + expiry_date.month)) + (expiry_date.day > today.day ? 1 : 0)
    # month_difference = ((today - effectivity_date) / 30).to_f.round
  end


end
