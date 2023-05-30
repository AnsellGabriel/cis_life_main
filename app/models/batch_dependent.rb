class BatchDependent < ApplicationRecord
  belongs_to :batch
  belongs_to :member_dependent
  belongs_to :agreement_benefit

  def get_total_premium
    self.agreement_benefit.product_benefits.sum(:premium)
  end

  def set_premium_and_service_fees(relationship)
    insured_type =  case relationship
      when 'Spouse'
        2
      when 'Parent'
        3
      when 'Children'
        4
      when 'Sibling'
        5
    end

    gr = self.batch.group_remit
    terms = self.batch.group_remit.terms
    agreement_benefit = gr.agreement.agreement_benefits.find_by(insured_type: insured_type)

    self.agreement_benefit_id = agreement_benefit.id
    self.premium = ((self.get_total_premium / 12.to_d) * terms) 
    self.coop_sf_amount = (gr.get_coop_sf/100.to_d) * self.premium
    self.agent_sf_amount = (gr.get_agent_sf/100.to_d) * self.premium
  end
end
