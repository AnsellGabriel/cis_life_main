module Counter
	extend ActiveSupport::Concern

	included do
		def counters
			@batch_count = @group_remit.batches.size
			@principal_count = @batches_container.size
			@dependent_count = @batches_dependents.size
			@batch_without_beneficiaries_count = @group_remit.batches_without_beneficiaries.size
			@batch_without_batch_health_dec_count = @group_remit.batches_without_health_dec.size
		end
	end

end