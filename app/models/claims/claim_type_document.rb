class Claims::ClaimTypeDocument < ApplicationRecord
  belongs_to :claim_type, class_name: 'Claims::ClaimType', optional: true
  belongs_to :claim_document, optional: true, dependent: :destroy

  has_one :claim_attachment, dependent: :destroy
  has_many :claim_document_requests, class_name: "Claims::ClaimDocumentRequest", dependent: :destroy

  def to_s
    name
  end
end
