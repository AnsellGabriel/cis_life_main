module Container
	extend ActiveSupport::Concern

	included do
		def containers
			@batches_container = @group_remit.batches.includes({coop_member: :member})
			@batches_dependents = BatchDependent.where(batch: @batches_container)
			# @single_premium = @batches_container[0].premium if @batches_container[0].present?
			# @single_dependent_premium = @batches_dependents[0].premium if @batches_dependents[0].present?
		end
	end

end