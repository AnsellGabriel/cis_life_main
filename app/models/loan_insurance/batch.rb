class LoanInsurance::Batch < Batch
  include CoverageStatus
  self.table_name = "loan_insurance_batches"


  validate :agreement_benefit, unless: :skip_validation # skip agreement_benefit validation
  validates_presence_of :date_release, :date_mature, :coop_member_id, :insurance_status, :loan_amount, :effectivity_date, :expiry_date

  belongs_to :group_remit, class_name: "LoanInsurance::GroupRemit", foreign_key: "group_remit_id"
  belongs_to :loan, class_name: "LoanInsurance::Loan", foreign_key: "loan_insurance_loan_id"
  belongs_to :rate, class_name: "LoanInsurance::Rate", foreign_key: "loan_insurance_rate_id"

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


  def process_batch
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
      if agreement.transferred_date.present? && (agreement.transferred_date >= coop_member.membership_date)
        self.status = :transferred
      else
        self.status = :recent
      end
    end

    # requires no health declaration if loan amount is less than or equal to agreement's nel
    if self.loan_amount <= agreement.nel
      self.valid_health_dec = true
    end

    if self.rate.nil?
      loan_rate
    else
      calculate_values(agreement, loan_rate)
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
    self.premium = (self.loan_amount / 1000) * (sub_rate * self.terms)

    if unused_loan_id
      previous_batch = LoanInsurance::Batch.find(unused_loan_id)
      unused_term = compute_terms(previous_batch.expiry_date, effectivity_date)
      self.unused = (previous_batch.loan_amount / 1000 ) * (rate.monthly_rate * unused_term)
      self.premium_due = self.premium - unused
    else
      self.unused = 0
      self.premium_due = self.premium
    end

    self.agent_sf_amount = calculate_service_fee(self.group_remit.agreement.agent_sf, self.premium_due)
    self.coop_sf_amount = calculate_service_fee(self.group_remit.agreement.coop_sf, self.premium_due)
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

  def calculate_values(agreement, loan_rate)
    # self.premium = (loan_amount / 1000 ) * (rate.monthly_rate * terms)
    self.premium = (loan_amount / 1000 ) * ((rate.annual_rate / 12) * terms)

    if unused_loan_id
      previous_batch = LoanInsurance::Batch.find(unused_loan_id)
      previous_batch.update(status: :terminated)

      unused_term = compute_terms(previous_batch.expiry_date, effectivity_date)
      self.unused = (previous_batch.loan_amount / 1000 ) * (rate.monthly_rate * unused_term)
      self.premium_due = premium - unused
    else
      self.unused = 0
      self.premium_due = premium
    end

    if self.premium_due < 0
      self.excess = self.premium_due.abs
      self.premium_due = 0
    end

    # self.agent_sf_amount = calculate_service_fee(agreement.agent_sf, premium_due)
    # self.coop_sf_amount = calculate_service_fee(agreement.coop_sf, premium_due)
    self.agent_sf_amount = calculate_service_fee(loan_rate.agent_sf, premium_due)
    self.coop_sf_amount = calculate_service_fee(loan_rate.coop_sf, premium_due)
  end

  def previous_loan
    LoanInsurance::Batch.find(unused_loan_id)
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
    (expiry_date.year - effectivity_date.year) * 12 + (expiry_date.month - effectivity_date.month) + (expiry_date.day > effectivity_date.day ? 1 : 0)
  end

  def expiry_and_today_month_diff(expiry_date)
    today = Date.today

    month_difference = ((today.year * 12 + today.month) - (expiry_date.year * 12 + expiry_date.month)) + (expiry_date.day > today.day ? 1 : 0)
  end


end
