class Claims::ClaimTypeBenefit < ApplicationRecord
  belongs_to :claim_type, class_name: 'Claims::ClaimType'
  belongs_to :benefit
end
