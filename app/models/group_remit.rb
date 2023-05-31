class GroupRemit < ApplicationRecord
  belongs_to :agreement
  belongs_to :anniversary, optional: true
  has_many :batches, dependent: :destroy

  def compute_save_premium_commissions
    self.gross_premium = gross_premium
    self.coop_commission = total_coop_commissions
    self.agent_commission = total_agent_commissions
    self.net_premium = net_premium - total_agent_commissions
    self.effectivity_date = Date.today
    self.submitted = true
  end

  def coop_member_ids
    self.batches.pluck(:coop_member_id)
  end

  def batches_dependents
    BatchDependent.joins(batch: :group_remit)
      .where(group_remits: {id: self.id})
  end

  def set_premium(insured_type)
    self.agreement.agreement_benefits.find_by(insured_type: insured_type).product_benefits[0].premium
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
  
  def batches_without_beneficiaries
    batches.where.not(id: self.batches.joins(:batch_beneficiaries).select(:id))
  end

  def batches_without_health_dec
    batches.where(status: :recent).where.not(id: self.batches.joins(:batch_health_dec).select(:id))
  end

  def all_batches_have_beneficiaries?
    batches.all? { |batch| batch.batch_beneficiaries.exists? }
  end

  def set_terms_and_expiry_date(anniversary_date)
    terms = set_terms(anniversary_date)
    self.terms = terms <= 0 ? terms + 12 : terms
    self.expiry_date = terms <= 0 ? anniversary_date.next_year : anniversary_date
  end

  def set_terms(anniversary_date)
    (anniversary_date.year * 12 + anniversary_date.month) - (Date.today.year * 12 + Date.today.month)
  end

  def self.expiry_dates
    pluck(:expiry_date).map { |date| date.strftime("%m-%d") }
  end
end

