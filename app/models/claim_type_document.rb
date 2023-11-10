class ClaimTypeDocument < ApplicationRecord
  belongs_to :claim_type, optional: true
  belongs_to :document, optional: true

  def to_s
    self.document
  end
end
