class ClaimTypeDocument < ApplicationRecord
  belongs_to :claim_type, optional: true
  belongs_to :document, optional: true

  has_one :claim_attachment, dependent: :destroy

  def to_s
    self.document
  end
end
