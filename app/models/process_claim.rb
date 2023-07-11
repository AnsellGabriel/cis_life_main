class ProcessClaim < ApplicationRecord
  
  validates_presence_of :cooperative_id, :agreement_id, :batch_id, :date_incident, :entry_type, :batch_beneficiary_id, :claimant_email, :claimant_contact_no, :nature_of_claim

  enum nature_of_claim: {
    LI: 0, # Life
    HIB: 1, # Hospital Income Benefit 
    AMR: 2, # Accidental Medical Reimbursement
    AD: 3, # Accidental Dismemberment
    TPD: 4 # Total & Permanent Disability
  }

  belongs_to :cooperative
  belongs_to :agreement
  belongs_to :batch
  has_many :claim_documents
  accepts_nested_attributes_for :claim_documents

end
