class BatchPresenter
    def initialize(batch)
		@batch = batch
	end

    def capitalized_insured_type
        @batch.agreement_benefit
            .insured_type
            .gsub('_', ' ')
            .split(' ')
            .drop(1)
            .join(' ')
            .upcase
    end
end