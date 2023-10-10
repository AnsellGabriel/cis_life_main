class ProcessClaim < ApplicationRecord
  attr_accessor :batch_id

  validates_presence_of :cooperative_id, :agreement_id, :entry_type, :claimant_name, :relationship, :claimant_email, :claimant_contact_no

  enum nature_of_claim: {
    LIFE: 0, # Life
    HIB: 1, # Hospital Income Benefit
    AMR: 2, # Accidental Medical Reimbursement
    AD: 3, # Accidental Dismemberment
    TPD: 4, # Total & Permanent Disability
    ADD: 5 # Accidental Death & Dismemberment
  }

  enum status: {
    approved: 0,
    denied: 1,
    pending: 2,
    reconsider: 3,
    process: 4
  }

  enum claimant_relation: {
    "Spouse" => 0,
    "Parent" => 1,
    "Sibling" => 2,
    "Child" => 3
  }

  enum claim_route: {
    file_claim: 0,
    submitted: 1, # Claims filed
    claim_filed: 2,
    processing: 3, # processing
    evaluation: 4,
    vp_evaluation: 5,
    president_evaluation: 6,
    process_completed: 7, # approved
    payment_procedure: 8, # payment
    denied_claim: 9, # denied
    reconsider_review: 10,
    pending_claim: 11
  }

  

  def self.get_route (i)
    claim_routes.key(i)
  end

  def display_route(claim_routes)
    claim_route.to_s.humanize.titleize
  end

  def get_benefit_claim_total(pc)
    ClaimBenefit.where(process_claim: pc).sum(:amount)
  end

  def get_age
    today = self.date_incident
    birthdate = self.claimable.birthdate
    age = today.year - birthdate.year

    # Adjust age if the user's birthday hasn't occurred yet this year
    age -= 1 if today < birthdate + age.years
    age
  end

  belongs_to :claimable, polymorphic: true
  belongs_to :cooperative
  belongs_to :agreement
  belongs_to :agreement_benefit
  belongs_to :cause, optional: true
  belongs_to :claim_type
  has_many :process_track, as: :trackable, dependent: :destroy
  has_one :claim_cause, dependent: :destroy
  has_many :claim_benefits, dependent: :destroy
  has_many :claim_coverages, dependent: :destroy
  has_many :claim_remarks, dependent: :destroy
  has_many :claim_attachments, dependent: :destroy
  has_many :claim_confinements, dependent: :destroy
  accepts_nested_attributes_for :claim_cause
  # belongs_to :batch
  has_many :claim_documents, dependent: :destroy
  accepts_nested_attributes_for :claim_documents

end
