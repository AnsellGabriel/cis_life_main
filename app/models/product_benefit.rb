class ProductBenefit < ApplicationRecord
  belongs_to :agreement_benefit
  belongs_to :benefit

  def self.total_cov_amt(batches)
    joins(agreement_benefit: :batches).where('batches.id IN (?)', batches.pluck(:id)).where('product_benefits.benefit_id = ?', 1).sum(:coverage_amount)
  end
end
