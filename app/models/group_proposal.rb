class GroupProposal < ApplicationRecord
  belongs_to :cooperative
  belongs_to :plan
  belongs_to :plan_unit
  has_one :agreement_proposal
  has_one :agreement, through: :agreement_proposal
  

  validates_presence_of :cooperative, :plan, :plan_unit


  def create_agreement(ctr, current_user)

    agreement = self.build_agreement(
      cooperative: self.cooperative,
      plan: self.plan,
      agent: current_user.userable, # change value to actual agent_id
      moa_no: "#{self.plan.acronym}-#{self.cooperative.acronym}-#{ctr}",
      entry_age_from: self.plan.entry_age_from,
      entry_age_to: self.plan.entry_age_to,
      exit_age: self.plan.exit_age,
      contestability: 12,
      minimum_participation: self.plan.min_participation,
      # @agreement.proposal_id = @group_proposal.id     # default
      nel: 25000,     # default value
      nml: 2000000,   # default value
      coop_sf: 10,   # change this value
      agent_sf: 10,   # change this value
      anniversary_type: "Single"
    )
    # agreement.save!
    if self.plan_id == 7 #KOOPamilya
      abs = KoopamilyaAb.all
      abs.each do |ab|
        agreement_benefits = agreement.agreement_benefits.build(
          name: ab.name,
          plan: self.plan,
          min_age: ab.min_age,
          max_age: ab.max_age,
          insured_type: ab.insured_type,
          exit_age: ab.exit_age,
          with_dependent: ab.principal? ? true : false
        )
        prem = 480
        pbs = ab.koopamilya_pbs.each do |ub|
        # self.plan_unit.unit_benefits.each do |ub|
          pb = agreement_benefits.product_benefits.build(
            coverage_amount: ub.coverage_amount,
            benefit: ub.benefit,
            premium: ab.principal? && ub.benefit.id == 1 ? prem : 0
          )
        end
      end
    
    #SIP
    elsif self.plan_id == 6
      abs = SipAb.all
      abs.each do |ab|
        agreement_benefit = agreement.agreement_benefits.build(
          name: ab.name,
          min_age: ab.min_age,
          max_age: ab.max_age,
          insured_type: ab.insured_type,
          exit_age: ab.exit_age,
          with_dependent: ab.principal? ? true : false
        )
        ab.sip_pbs.where(plan_unit_id: self.plan_unit_id).each do |pb|
          prod_benefit = agreement_benefit.product_benefits.build(
            coverage_amount: pb.coverage_amount,
            premium: pb.premium,
            benefit: pb.benefit
          )

        end
      end

    elsif self.plan_id == 8 #SII
      annual_rate = 10 #per annum
      loan_rate = agreement.loan_rates.build(
        min_age: agreement.entry_age_from,
        max_age: agreement.entry_age_to,
        annual_rate: annual_rate,
        monthly_rate: (annual_rate / 12),
        min_amount: 1,
        max_amount: 300000,
        coop_sf: 10, #change value
        agent_sf: 0 #change value
      )

    else
      #GBLISS
      agreement_benefits = agreement.agreement_benefits.build(
        name: "Principal",
        plan: self.plan,
        min_age: agreement.entry_age_from,
        max_age: agreement.entry_age_to,
        insured_type: 1,
        exit_age: agreement.exit_age
      )
      # agreement_benefits.save!
  
      # prem = self.plan_unit.total_prem / self.plan_unit.unit_benefits.count
      prem = self.plan_unit.total_prem 
        self.plan_unit.unit_benefits.each do |ub|
          pb = agreement_benefits.product_benefits.build(
            coverage_amount: ub.coverage_amount,
            benefit: ub.benefit,
            premium: ub.benefit_id == 1 ? prem : 0
          )
          # pb.save!
        end
    end

  end

end
