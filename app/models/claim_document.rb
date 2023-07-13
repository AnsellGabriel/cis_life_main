class ClaimDocument < ApplicationRecord
  mount_uploader :document, DocumentUploader
  belongs_to :process_claim


  enum document_type: {
    death_certificate: 1,
    physician_statement: 2,
    police_report: 3,
    medical_certificate: 4,
    claimant_statement: 5,
    loan_ledger: 6,
    insurance_certificate: 7,
    official_receipt: 8,
    hospital_bills: 9
  }

end
