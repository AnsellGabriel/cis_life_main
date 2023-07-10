class ProcessClaim < ApplicationRecord
  
  # validates_presence_of :cooperative_id, :agreement_id, :batch_id, :date_incident, :entry_type, :batch_beneficiary_id, :claimant_email, :claimant_contact_no, :nature_of_claim

  enum nature_of_claim: {
    life: 0,
    hospitalization: 1,
    reimbursement: 2,
    dismemberment: 3,
    disability: 4,
  }

  belongs_to :cooperative
  belongs_to :agreement
  belongs_to :batch
  has_many :claim_documents
  accepts_nested_attributes_for :claim_documents

end
