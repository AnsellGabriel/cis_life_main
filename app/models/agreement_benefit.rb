class AgreementBenefit < ApplicationRecord
	validates_presence_of :name, :min_age, :max_age, :insured_type

  has_many :batches
  has_many :batch_dependents
  has_many :product_benefits

  belongs_to :agreement
  belongs_to :proposal
  belongs_to :options


  enum insured_type: { 
    principal: 1, 
    dependent_spouse: 2,
    dependent_parent: 3,
    dependent_children: 4,
    dependent_sibling: 5,
    ranking_bod: 6,
    ranking_senior_officer: 7,
    ranking_junior_officer: 8,
    ranking_rank_and_file: 9
  }
end
