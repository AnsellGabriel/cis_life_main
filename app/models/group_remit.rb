class GroupRemit < ApplicationRecord
  belongs_to :agreement
  belongs_to :anniversary
  
  has_many :batches, dependent: :destroy

  def coop_member_ids
    self.batches.pluck(:coop_member_id)
  end

  def batches_dependents
    BatchDependent.joins(batch: :group_remit)
      .where(group_remits: {id: self.id})
  end

  def principal_premium
    self.agreement.agreement_benefits.find_by(insured_type: 1).product_benefit.premium
  end

  def dependent_premium
    self.agreement.agreement_benefits.find_by(insured_type: 2).product_benefit.premium
  end

  def get_coop_sf
    self.agreement.agreement_benefits[0].proposal.coop_sf
  end

  def get_agent_sf
    self.agreement.agreement_benefits[0].proposal.agent_sf
  end

  def total_dependent_premiums
    self.batches.joins(:batch_dependents).sum('batch_dependents.premium')
  end

  def dependent_coop_commissions
    self.batches.joins(:batch_dependents).sum('batch_dependents.coop_sf_amount')
  end

  def dependent_agent_commissions
    self.batches.joins(:batch_dependents).sum('batch_dependents.agent_sf_amount')
  end

  def total_principal_premium
    self.batches.sum(:premium)
  end

  def gross_premium
    self.total_principal_premium + self.total_dependent_premiums
  end

  def coop_commissions
    self.batches.sum(:coop_sf_amount)
  end

  def total_coop_commissions
    self.coop_commissions + self.dependent_coop_commissions
  end

  def total_agent_commissions
    self.agent_commissions + self.dependent_agent_commissions
  end

  def agent_commissions
    self.batches.sum(:agent_sf_amount)
  end

  def net_premium
    self.gross_premium - self.total_coop_commissions
  end
end

