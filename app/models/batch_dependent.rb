class BatchDependent < ApplicationRecord
  include Calculate
  validate :validate_age

  belongs_to :batch
  belongs_to :member_dependent
  belongs_to :agreement_benefit
  has_many :process_claims, as: :claimable, dependent: :destroy

  
  # [relationship] is used to retrieve the value from the hash based on the given relationship parameter
  def insured_type(relationship)
    {
      'Spouse' => 2,
      'Parent' => 3,
      'Child' => 4,
      'Sibling' => 5
    }[relationship]
  end

  def validate_age
    age = self.member_dependent.age 

    if age < self.agreement_benefit.min_age || age > self.agreement_benefit.max_age
      errors.add(:age, "must be between #{self.agreement_benefit.min_age.to_i} and #{self.agreement_benefit.max_age.to_i}. Dependent's age is #{age}")
    end
  end
end
