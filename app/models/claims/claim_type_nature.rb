class Claims::ClaimTypeNature < ApplicationRecord
  belongs_to :claim_type, class_name: 'Claims::ClaimType'

  def to_s 
    name
  end
end
