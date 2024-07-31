module Calculate
  extend ActiveSupport::Concern

  included do
    def set_premium_and_service_fees(insured_type, group_remit, premium = nil, savings_amount = nil)
      # agreement_benefit = group_remit.agreement.agreement_benefits.find_by(insured_type: insured_type)
      # if savings_amount.nil?
      agreement_benefit = group_remit.agreement.agreement_benefits.find_by(id: insured_type)

      if agreement_benefit.nil?
        agreement_benefit = group_remit.agreement.agreement_benefits.find_by(insured_type: insured_type)
      end

      self.agreement_benefit_id = agreement_benefit.id
      calculate_premium_and_fees(premium.present? ? premium : total_premium, group_remit)

      if premium.present?
        if group_remit.terms <= group_remit.agreement.minimum_term
          self.system_premium = group_remit.agreement.minimum_premium
        else
          self.system_premium = calculate_premium(total_premium, group_remit.terms)
        end
      end
    end

    def calculate_premium_and_fees_sii(group_remit, savings_amount, rate)
      amount = savings_amount.to_d
      monthly_rate = (rate.annual_rate / 12)
      self.amount = amount
      self.premium = (((amount / 1000) * monthly_rate) * group_remit.terms)
      self.coop_sf_amount = calculate_service_fee(group_remit.get_coop_sf, self.premium)

      set_agent_service(group_remit)
    end

    def calculate_premium_and_fees(premium, group_remit)
      if group_remit.terms <= group_remit.agreement.minimum_term
        self.premium = group_remit.agreement.minimum_premium
      else
        self.premium = calculate_premium(premium, group_remit.terms)
      end
      self.coop_sf_amount = calculate_service_fee(group_remit.get_coop_sf, self.premium)

      set_agent_service(group_remit)
    end

    def manual_premium_and_fees(premium, group_remit)
      self.premium = premium.to_f
      self.coop_sf_amount = calculate_service_fee(group_remit.get_coop_sf, self.premium)

      set_agent_service(group_remit)
    end

    def calculate_service_fee(service_fee_percentage, premium)
      if service_fee_percentage
        (service_fee_percentage / 100.to_d) * premium
      else
        0
      end
    end

    def total_premium
      agreement_benefit.product_benefits.sum(:premium)
    end

    def set_agent_service(group_remit)
      if group_remit.agreement.comm_type == "Net Commission"
        self.agent_sf_amount = calculate_service_fee(group_remit.get_agent_sf, self.premium - self.coop_sf_amount)
      else
        self.agent_sf_amount = calculate_service_fee(group_remit.get_agent_sf, self.premium)
      end
    end

    def calculate_premium(total_premium, terms)
      (total_premium / 12.to_d) * terms
    end
  end
end
