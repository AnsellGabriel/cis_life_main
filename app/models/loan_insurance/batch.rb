class LoanInsurance::Batch < Batch
  include CoverageStatus

  self.table_name = "loan_insurance_batches"

  # skip agreement_benefit validation
  validate :agreement_benefit, unless: :skip_validation
  validates_presence_of :date_release, :date_mature, :coop_member_id, :insurance_status, :loan_amount, :effectivity_date, :expiry_date

  belongs_to :group_remit, class_name: 'LoanInsurance::GroupRemit', foreign_key: 'group_remit_id'
  belongs_to :loan, class_name: 'LoanInsurance::Loan', foreign_key: 'loan_insurance_loan_id'
  belongs_to :rate, class_name: 'LoanInsurance::Rate', foreign_key: 'loan_insurance_rate_id'

  # belongs_to :retention, class_name: 'LoanInsurance::Retention', foreign_key: 'loan_insurance_retention_id'
  has_many :details, class_name: 'LoanInsurance::Detail'
  has_many :batch_health_decs, as: :healthdecable, dependent: :destroy
  has_many :batch_remarks, as: :remarkable, dependent: :destroy

  def process_batch
    return :no_dates if effectivity_date.nil? || expiry_date.nil?

    agreement = group_remit.agreement
    set_terms_and_age
    find_existing_coverages(agreement)
    loan_rate = find_loan_rate(agreement)

    if loan_rate.nil?
      :no_loan_rate
    else
      calculate_values(agreement)
      true
    end
  end

  def get_terms
    terms
  end

 

  private

  def skip_validation
    true 
  end

  def set_terms_and_age
    self.terms = compute_terms(expiry_date, effectivity_date)
    self.insurance_status = :for_review
    self.age = coop_member.age(effectivity_date)
  end

  def find_loan_rate(agreement)
    self.rate = agreement.loan_rates.where("min_age <= ? AND max_age >= ?", age, age).first
  end

  def calculate_values(agreement)
    self.premium = (loan_amount / 1000 ) * (rate.monthly_rate * terms)

    if unused_loan_id
      previous_batch = LoanInsurance::Batch.find(unused_loan_id)
      unused_term = compute_terms(previous_batch.expiry_date, effectivity_date)
      self.unused = (previous_batch.loan_amount / 1000 ) * (rate.monthly_rate * unused_term)
      self.premium_due = premium - unused
    else
      self.unused = 0
      self.premium_due = premium
    end

    self.agent_sf_amount = calculate_service_fee(agreement.agent_sf, premium_due)
    self.coop_sf_amount = calculate_service_fee(agreement.coop_sf, premium_due)
  end

  def calculate_service_fee(service_fee_percentage, premium)
    (service_fee_percentage / 100.to_d) * premium
  end

  def find_existing_coverages(agreement)
    existing_coverage = agreement.agreements_coop_members.where(coop_member_id: coop_member.id).order(created_at: :desc).first

    if existing_coverage
      update_batch_and_existing_coverage(self, existing_coverage, group_remit)
    else
      create_new_batch_coverage(agreement, coop_member, self )
    end
  end

  def compute_terms(expiry_date, effectivity_date)
    (expiry_date.year - effectivity_date.year) * 12 + (expiry_date.month - effectivity_date.month) + (expiry_date.day > effectivity_date.day ? 1 : 0)
  end


end
