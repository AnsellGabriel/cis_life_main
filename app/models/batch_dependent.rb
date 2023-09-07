class BatchDependent < ApplicationRecord
  include Calculate

  # validate :validate_age
  # batch.insurance_status
  enum insurance_status: {
    approved: 0,
    denied: 1,
    pending: 2,
    for_review: 3,
    for_reconsideration: 4
  }

  belongs_to :batch
  belongs_to :member_dependent
  belongs_to :agreement_benefit
  has_many :batch_health_decs, as: :healthdecable, dependent: :destroy
  alias_attribute :health_declaration, :batch_health_decs
  has_many :process_claims, as: :claimable, dependent: :destroy
  has_many :batch_remarks, as: :remarkable, dependent: :destroy
  alias_attribute :remarks, :batch_remarks

  delegate :full_name, to: :member_dependent
  # [relationship] is used to retrieve the value from the hash based on the given relationship parameter
  def insured_type(relationship)
    {
      'SPOUSE' => 2,
      'PARENT' => 3,
      'CHILD' => 4,
      'SIBLING' => 5
    }[relationship]
  end

  # def validate_age
  #   age = self.member_dependent.age 

  #   if age < self.agreement_benefit.min_age || age > self.agreement_benefit.max_age
  #     errors.add(:age, "must be between #{self.agreement_benefit.min_age.to_i} and #{self.agreement_benefit.max_age.to_i}. Dependent's age is #{age}")
  #   end
  # end

  def update_insurance_status(status)
    self.update(insurance_status: status)
  end
end
