class MemberDependent < ApplicationRecord
  attr_accessor :claims
  
  before_validation :name_to_upcase

  validates_presence_of :first_name, :last_name, :birth_date, :relationship
  validate :validate_relationship

  belongs_to :member

  has_many :batch_dependents, dependent: :destroy
  has_many :batches, through: :batch_dependents

  has_many :batch_beneficiaries, dependent: :destroy
  has_many :batches, through: :batch_beneficiaries

  def to_s
    full_name
  end

  def age
    today = Date.today
    age = today.year - birth_date.year

    if today.month < birth_date.month || (today.month == birth_date.month && today.day < birth_date.day)
      age -= 1
    end

    age
  end

  def full_name
    "#{self.last_name}, #{self.first_name} #{self.middle_name} #{self.suffix}"
  end

  private
  
  def validate_relationship  
    allowed_relationships = case self.member.civil_status
                              when "Married"
                                ['Spouse', 'Child']
                              when "Single"
                                ['Parent', 'Sibling']
                              else
                                ['Parent', 'Child', 'Sibling']
                            end
  
    unless allowed_relationships.include?(self.relationship) 
      errors.add(:relationship, "allowed: #{allowed_relationships.join(', ')}")
    end
  end
  

  def name_to_upcase
    self.last_name = self.last_name.upcase
    self.first_name = self.first_name.upcase
    self.middle_name = self.middle_name.upcase
    self.suffix = self.suffix == nil ? '' : self.suffix.upcase
    # repeat the above line for each field you want to make all caps
  end
end
