class SipAb < ApplicationRecord
  has_many :sip_pbs

  INSURED_TYPES = ["principal", "dependent_spouse", "dependent_parent", "dependent_children", "dependent_sibling"]

  enum insured_type: {
    principal: 1,
    dependent_spouse: 2,
    dependent_parent: 3,
    dependent_children: 4,
    dependent_sibling: 5
  }
  
end
