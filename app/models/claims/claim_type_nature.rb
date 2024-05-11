class Claims::ClaimTypeNature < ApplicationRecord
  # belongs_to :claim_type, class_name: 'Claims::ClaimType', optional: true
  validates_presence_of :name
  def to_s 
    name
  end
end
