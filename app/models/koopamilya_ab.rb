class KoopamilyaAb < ApplicationRecord

  has_many :koopamilya_pbs

  INSURED_TYPE = ["principal", "dependent_spouse", "dependent_parent", "dependent_children", "dependent_sibling"]
  GROUPINGS = ["less_3_months", "three_to_12_months", "over_12_months"]

  enum insured_type: {
    principal: 1,
    dependent_spouse: 2,
    dependent_parent: 3,
    dependent_children: 4,
    dependent_sibling: 5
  }

  enum groupings: {
    less_3_months: 1,
    three_to_12_months: 2,
    over_12_months: 3
  }
end
