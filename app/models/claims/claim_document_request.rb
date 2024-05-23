class Claims::ClaimDocumentRequest < ApplicationRecord
  belongs_to :process_claim, class_name: "ProcessClaim"
  belongs_to :claim_type_document, class_name: "ClaimTypeDocument"
end
