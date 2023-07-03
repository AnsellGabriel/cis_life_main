class ProcessClaim < ApplicationRecord
  attr_reader :claimant_email, :claimant_contact_no

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
end
