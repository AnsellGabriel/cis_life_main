class AgreementBenefit < ApplicationRecord
  before_save :upcase_name
	validates_presence_of :name, :min_age, :max_age, :exit_age, :insured_type # :with_dependent

  scope :with_name_like, -> (name) { where("name LIKE ?", "%#{name}%") }

  has_many :batches
  has_many :batch_dependents
  has_many :product_benefits
  has_many :prcoess_claims
  belongs_to :agreement, optional: true
  belongs_to :plan, optional: true
  belongs_to :proposal, optional: true
#   belongs_to :option, optional: true

#   belongs_to :agreement
#   belongs_to :proposal
  # belongs_to :options
  def to_s
    name
  end

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

  def upcase_name
    self.name = self.name.upcase
  end

  def get_product_benefits
    self.product_benefits
  end
end
