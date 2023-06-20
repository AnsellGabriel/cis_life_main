module Calculate
	extend ActiveSupport::Concern

	included do
		def set_premium_and_service_fees(insured_type, group_remit)
			agreement_benefit = group_remit.agreement.agreement_benefits.find_by(insured_type: insured_type)
			self.agreement_benefit_id = agreement_benefit.id
			calculate_premium_and_fees(total_premium, group_remit)
		end

		def calculate_premium_and_fees(premium, group_remit)
			self.premium = calculate_premium(premium, group_remit.terms)
			self.coop_sf_amount = calculate_service_fee(group_remit.get_coop_sf, self.premium)
			self.agent_sf_amount = calculate_service_fee(group_remit.get_agent_sf, self.premium)
		end
	
		def calculate_premium(total_premium, terms)
			(total_premium / 12.to_d) * terms
		end
		
		def calculate_service_fee(service_fee_percentage, premium)
			(service_fee_percentage / 100.to_d) * premium
		end

		def total_premium
			agreement_benefit.product_benefits.sum(:premium)
		end
	end
end