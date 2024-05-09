class Claims::ClaimType < ApplicationRecord
  before_save :remove_whitespace

  validates_presence_of :name
  has_many :claim_type_benefits, class_name: 'Claims::ClaimTypeBenefit' , dependent: :destroy
  has_many :claim_type_documents, class_name: 'Claims::ClaimTypeDocument' , dependent: :destroy
  has_many :claim_type_natures, class_name: 'Claims::ClaimTypeNature', dependent: :destroy


  def to_s
    name
  end

  def remove_whitespace
    self.name = self.name.strip
  end
end
