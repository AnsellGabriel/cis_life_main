class Claims::ClaimTypeAgreement < ApplicationRecord
  belongs_to :agreement
  belongs_to :claim_type, class_name: 'Claims::ClaimType'

  def to_s 
    claim_type.name
  end
end
