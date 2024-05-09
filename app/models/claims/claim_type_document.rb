class Claims::ClaimTypeDocument < ApplicationRecord
  belongs_to :claim_type, class_name: 'Claims::ClaimType', optional: true
  belongs_to :claim_document, optional: true, dependent: :destroy

  has_one :claim_attachment, dependent: :destroy

  def to_s
    name
  end
end
