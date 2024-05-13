class ClaimType < ApplicationRecord
  before_save :remove_whitespace

  validates_presence_of :name
  has_many :claim_type_benefits, dependent: :destroy
  has_many :claim_type_documents, class_name: 'Claims::ClaimTypeDocument' , dependent: :destroy
  # has_many :claim_type_natures, dependent: :destroy


  def to_s
    name
  end

  def remove_whitespace
    self.name = self.name.strip
  end
end
