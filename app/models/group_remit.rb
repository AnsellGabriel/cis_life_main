class GroupRemit < ApplicationRecord
  belongs_to :agreement
  belongs_to :anniversary, optional: true
  has_many :batches, dependent: :destroy

  enum status: {
    pending: 0,
    active: 1,
    renewal: 2,
    renewed: 3,
    expired: 4
  }

  def renew
    new_group_remit = self.dup
    new_group_remit.set_terms_and_expiry_date(self.expiry_date)
    new_group_remit.expiry_date = self.expiry_date + 1.year # Assuming the renewal duration is 1 year from the current date
    new_group_remit.status = :renewal
    new_group_remit.effectivity_date = nil
    new_group_remit.save

    removed_batches = [] # To store the batches that are removed from the renewal

    self.batches.each do |batch|
      if batch.member_details.age >= batch.agreement_benefit.min_age && batch.member_details.age <= batch.agreement_benefit.max_age
        new_batch = batch.dup
        new_batch.group_remit_id = new_group_remit.id
        new_batch.status = :renewal
        # byebug
        new_batch.save

        if batch.batch_dependents.present?
          batch.batch_dependents.each do |dependent|
            new_dependent = dependent.dup
            new_dependent.batch_id = new_batch.id
            new_dependent.save
          end
        end

        batch.batch_beneficiaries.each do |beneficiary|
          new_beneficiary = beneficiary.dup
          new_beneficiary.batch_id = new_batch.id
          new_beneficiary.save
        end

      else
        removed_batches << batch
      end
    end
    
    renewal_result = {
      new_group_remit: new_group_remit,
      removed_batches: removed_batches
    }
  end

  def set_total_premiums_and_fees
    self.gross_premium = gross_premium
    self.coop_commission = total_coop_commissions
    self.agent_commission = total_agent_commissions
    self.net_premium = net_premium - total_agent_commissions
    self.effectivity_date = Date.today
  end

  def set_renewed_status
    set_total_premiums_and_fees
    self.status = :renewed
  end

  def set_active_status
    set_total_premiums_and_fees
    self.status = :active
  end

  def coop_member_ids
    batches.pluck(:coop_member_id)
  end

  def batches_dependents
    BatchDependent.joins(batch: :group_remit)
      .where(group_remits: {id: self.id})
  end

  def set_premium(insured_type)
    agreement.agreement_benefits.find_by(insured_type: insured_type).product_benefits[0].premium
  end

  def get_coop_sf
    agreement.agreement_benefits[0].proposal.coop_sf
  end

  def get_agent_sf
    agreement.agreement_benefits[0].proposal.agent_sf
  end

  def total_dependent_premiums
    batches.joins(:batch_dependents).sum('batch_dependents.premium')
  end

  def dependent_coop_commissions
    batches.joins(:batch_dependents).sum('batch_dependents.coop_sf_amount')
  end

  def dependent_agent_commissions
    batches.joins(:batch_dependents).sum('batch_dependents.agent_sf_amount')
  end

  def total_principal_premium
    batches.sum(:premium)
  end

  def gross_premium
    total_principal_premium + total_dependent_premiums
  end

  def coop_commissions
    batches.sum(:coop_sf_amount)
  end

  def total_coop_commissions
    coop_commissions + dependent_coop_commissions
  end

  def total_agent_commissions
    agent_commissions + dependent_agent_commissions
  end

  def agent_commissions
    batches.sum(:agent_sf_amount)
  end

  def net_premium
    gross_premium - total_coop_commissions
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

