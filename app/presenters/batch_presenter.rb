class BatchPresenter
    def initialize(batch, agreement = nil)
		@batch = batch
        @agreement = agreement
	end

    def capitalized_insured_type
        # @batch.agreement_benefit
        #     .insured_type
        #     .gsub('_', ' ')
        #     .split(' ')
        #     .drop(1)
        #     .join(' ')
        #     .upcase
        @batch.agreement_benefit
            .name
            .upcase
    end

    def present_agreement_benefit
        @batch.agreement_benefit
    end

		def present_full_name
			if @batch.class == Batch
				@batch.coop_member.full_name
			else
				@batch.member_dependent.full_name
			end
		end

    def present_product_benefits
        if @agreement.plan.acronym == 'PMFC'
            @batch.get_term_insurance_product_benefit
        else
            @batch.agreement_benefit.product_benefits
        end
    end

    def present_product_info
        present_product_benefits.joins(:benefit).pluck(:acronym, :name, :coverage_amount)
    end
end