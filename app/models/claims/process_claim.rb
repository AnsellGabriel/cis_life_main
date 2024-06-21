class Claims::ProcessClaim < ApplicationRecord
  attr_accessor :batch_id, :coop_bank
  before_destroy :remove_from_loan_batch

  validates_presence_of :cooperative_id, :agreement_id, :entry_type, :claimant_name, :claimant_email, :claimant_contact_no, :date_incident

  def to_s
    claimable.coop_member.full_name.titleize
  end

  enum nature_of_claim: {
    LIFE: 0, # Life
    HIB: 1, # Hospital Income Benefit
    AMR: 2, # Accidental Medical Reimbursement
    AD: 3, # Accidental Dismemberment
    TPD: 4, # Total & Permanent Disability
    ADD: 5 # Accidental Death & Dismemberment
  }

  enum entry_type: {
    claim: 0,
    coop: 1
  }

  enum payout_type: {
    check_voucher: 0,
    debit_advice: 1
  }

  enum status: {
    approved: 0,
    denied: 1,
    pending: 2,
    reconsider: 3,
    process: 4,
    denied_due_to_non_compliance: 5,
    reconsider_approved: 6,
    reconsider_denied: 7
  }

  enum claimant_relation: {
    "Spouse" => 0,
    "Parent" => 1,
    "Sibling" => 2,
    "Child" => 3
  }

  enum claim_route: {
    coop_file: 0, #file_claim
    documentation_review: 1, #submitted # Claims filed
    claim_filed: 2,
    claim_review: 3, # processing
    evaluation: 4,
    evaluation_coso: 5,
    evaluation_president: 6,
    process_completed: 7, # approved
    payment_procedure: 8, # payment
    denied_claim: 9, # denied
    reconsider_review: 10,
    payment_rejected: 11, # if accounting reject the request for payment
    claimable: 12,
    paid: 13, # paid
    voucher_generated: 14,
    approve_audit: 15,
    pending_audit: 16,
    analyst_file: 17,
    non_compliant: 18,
    incomplete_document: 19,
    reconsider_coso: 20,
    verify_hardcopy_document: 21,
    issuance_denied_letter: 22,
    payment_preparation: 23,
    retrieval_documents: 24,
    pending_claim: 25,
    reinsurance_verification: 26,
    reinsurance_verified: 27
  }



  def self.get_route (i)
    claim_routes.key(i)
  end

  def payable
    cooperative
  end

  def display_route(claim_routes)
    claim_route.to_s.humanize.titleize
  end

  def get_benefit_claim_total
    # ClaimBenefit.where(process_claim: pc).sum(:amount)
    claim_benefits.sum(:amount)
  end

  def check_authority_level(max_amount)
    # raise 'error'
    if get_benefit_claim_total <= max_amount
      return true
    else
      return false
    end
  end

  def get_age
    unless self.date_incident.nil?
      today = self.date_incident
      birthdate = self.claimable.birthdate
      age = today.year - birthdate.year
  
      # Adjust age if the user's birthday hasn't occurred yet this year
      age -= 1 if today < birthdate + age.years
      
    else
      age = 0 
    end
  end

  def attach_document_status 
    required_docs = claim_type.claim_type_documents.where(required: true)
    uploaded_docs = claim_attachments

    missing_requested_docs = []
    if incomplete_document?
      requested_docs = claim_document_requests
      missing_requested_docs = requested_docs.pluck(:claim_type_document_id) - uploaded_docs.pluck(:claim_type_document_id)
    end
    
    missing_required_docs = required_docs.pluck(:id) - uploaded_docs.pluck(:claim_type_document_id)
    status = 1 if missing_requested_docs.any? || missing_required_docs.any?
    status_message = if missing_requested_docs.any?
               "Please upload the requested documents"
             elsif missing_required_docs.any?
               "Please upload the required documents"
             else
               "All required documents are uploaded"
             end
            
    {
      status: status,
      status_message: status_message
    }

  end

  def remove_from_loan_batch
    if self.loan_batch.present?
      self.loan_batch.process_claim_id = nil
      self.loan_batch.save
    end
  end

  belongs_to :claimable, polymorphic: true
  belongs_to :cooperative
  belongs_to :agreement
  belongs_to :agreement_benefit, optional: true
  belongs_to :cause, optional: true
  belongs_to :claim_type
  belongs_to :claim_type_nature, optional: true
  has_many :process_track, as: :trackable, dependent: :destroy
  has_one :claim_cause, dependent: :destroy
  has_one :claim_reinsurance, dependent: :destroy, class_name: "Claims::ClaimReinsurance"
  has_many :claim_benefits, dependent: :destroy
  has_many :claim_coverages, dependent: :destroy
  has_many :claim_remarks, dependent: :destroy
  has_many :claim_attachments, dependent: :destroy
  has_many :claim_document_requests, dependent: :destroy
  has_many :claim_confinements, dependent: :destroy
  has_many :claim_distributions, dependent: :destroy
  has_many :remarks, as: :remarkable, dependent: :destroy
  has_many :cf_availments, dependent: :destroy, class_name: "Claims::CfAvailment"
  has_one :loan_batch, class_name: "LoanInsurance::Batch"

  # has_one :claim_request_for_payment, dependent: :destroy
  has_many :voucher_requests, as: :requestable, dependent: :destroy, class_name: "Accounting::VoucherRequest"
  accepts_nested_attributes_for :claim_cause
  # belongs_to :batch
  has_many :claim_documents
  accepts_nested_attributes_for :claim_documents

end
