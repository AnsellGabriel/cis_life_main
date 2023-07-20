class ProcessClaim < ApplicationRecord
  attr_accessor :batch_id
  
  validates_presence_of :cooperative_id, :agreement_id, :batch_id, :date_incident, :entry_type, :claimant_email, :claimant_contact_no, :nature_of_claim

  enum nature_of_claim: {
    LI: 0, # Life
    HIB: 1, # Hospital Income Benefit 
    AMR: 2, # Accidental Medical Reimbursement
    AD: 3, # Accidental Dismemberment
    TPD: 4, # Total & Permanent Disability
    ADD: 5 # Accidental Death & Dismemberment
  }

  enum claim_route: {
    cooperative_filed: 0, # Claims filed
    claim_filed: 1,
    processing: 2, # processing 
    evaluation: 3,
    vp_evaluation: 4,
    president_evaluation: 5,
    process_completed: 6, # approved
    payment_procedure: 7, # payment
    denied_claim: 8, # denied
    reconsider_review: 9 
  }

  belongs_to :claimable, polymorphic: true
  belongs_to :cooperative
  belongs_to :agreement
  belongs_to :agreement_benefit
  # belongs_to :batch
  has_many :claim_documents, dependent: :destroy
  accepts_nested_attributes_for :claim_documents

end
