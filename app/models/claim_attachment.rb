class ClaimAttachment < ApplicationRecord
  belongs_to :process_claim
  belongs_to :claim_type_document
  has_one_attached :doc
end
