module Calculate
	extend ActiveSupport::Concern

	included do
		def set_premium_and_service_fees(insured_type, group_remit, term_insurance = false)
			# agreement_benefit = group_remit.agreement.agreement_benefits.find_by(insured_type: insured_type)
			agreement_benefit = group_remit.agreement.agreement_benefits.find_by(id: insured_type)
			if agreement_benefit.nil?
				agreement_benefit = group_remit.agreement.agreement_benefits.find_by(insured_type: insured_type)
			end
			self.agreement_benefit_id = agreement_benefit.id
			if term_insurance
				calculate_term_insurance(group_remit)
			else
				calculate_premium_and_fees(total_premium, group_remit)
			end
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

		def calculate_term_insurance(group_remit)
			product_benefit = self.agreement_benefit.product_benefits
                             .where(duration: self.duration)
                             .where("residency_floor <= ?", self.residency)
                             .where("residency_ceiling >= ?", self.residency)
                             .find_by(duration: self.duration)
			# byebug
			self.premium = product_benefit.premium if product_benefit

			# self.premium = self.agreement_benefit.product_benefits.find_by(duration: self.duration, residency: self.residency).premium
			self.coop_sf_amount = calculate_service_fee(group_remit.get_coop_sf, self.premium)
			self.agent_sf_amount = calculate_service_fee(group_remit.get_agent_sf, self.premium)
		end
	end
end