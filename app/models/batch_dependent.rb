class BatchDependent < ApplicationRecord
  include Calculate

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
end
