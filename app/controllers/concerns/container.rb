module Container
	extend ActiveSupport::Concern

	included do
		def containers
			@batches_container = @group_remit.batches.includes({coop_member: :member}).order(created_at: :desc)
			@batches_dependents = BatchDependent.where(batch: @batches_container)
		end
	end

end