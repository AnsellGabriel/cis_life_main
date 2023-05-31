module Container
	extend ActiveSupport::Concern

	included do
		def containers
			@batches_container = @group_remit.batches.order(created_at: :desc)
			@batches_dependents = @group_remit.batches_dependents
			@single_premium = @batches_container[0].premium if @batches_container[0].present?
			@single_dependent_premium = @batches_dependents[0].premium if @batches_dependents[0].present?
		end
	end

end