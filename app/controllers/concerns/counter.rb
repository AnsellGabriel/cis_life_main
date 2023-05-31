module Counter
	extend ActiveSupport::Concern

	included do
		def counters
			@batch_count = @group_remit.batches.count
			@principal_count = @batches_container.count
			@dependent_count = @batches_dependents.count
			@batch_without_beneficiaries_count = @group_remit.batches_without_beneficiaries.count
			@batch_without_batch_health_dec_count = @group_remit.batches_without_health_dec.count
		end
	end

end