class Claims::ClaimAttachment < ApplicationRecord
  belongs_to :process_claim, optional: true
  belongs_to :claim_type_document, optional: true
  has_one_attached :doc
end
