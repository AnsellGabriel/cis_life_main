class ClaimTypeDocument < ApplicationRecord
  belongs_to :claim_type
  belongs_to :document

  def to_s 
    self.document
  end
end
