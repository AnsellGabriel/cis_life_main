class ProductBenefit < ApplicationRecord
  validates_presence_of :coverage_amount, :premium, :benefit_id, :agreement_benefit_id

  belongs_to :agreement_benefit
  belongs_to :benefit

  def self.total_cov_amt(batches)
    joins(agreement_benefit: :batches).where('batches.id IN (?)', batches.pluck(:id)).where('product_benefits.benefit_id = ?', 1).sum(:coverage_amount)
  end

  def self.get_premium(batch)
    joins(agreement_benefit: :batches).where(batches: { id: batch.id }).sum(:premium)
  end

  def self.get_life_cov(batch)
    joins(agreement_benefit: :batches).find_by(batches: { id: batch.id }, benefit_id: 1).coverage_amount
  end
end
