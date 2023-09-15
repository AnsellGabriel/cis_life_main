class GroupRemitPresenter
	include Rails.application.routes.url_helpers

	def initialize(group_remit)
		@group_remit = group_remit
	end

	def is_none_anniversary?
		@group_remit.agreement.anniversary_type == 'none' || @group_remit.agreement.anniversary_type.nil?
	end

	def is_single_anniversary?
		@group_remit.agreement.anniversary_type == 'single'
	end

	def is_multiple_anniversary?
		@group_remit.agreement.anniversary_type == 'multiple'
	end

	def is_batch_remit?
		@group_remit.type == 'BatchRemit'
	end

	def is_remittance?
		@group_remit.type == 'Remittance'
	end



	def is_for_renewal?
		@group_remit.for_renewal?
	end

	def is_pending?
		@group_remit.pending?
	end

	def is_expired?
		@group_remit.expired?
	end

	def is_for_payment?
		@group_remit.for_payment?
	end

	

	def remaining_days
		remaining_days = (@group_remit.expiry_date - Date.today).to_i
	end

	def countdown_color
		if remaining_days <= 10
			"danger"
		elsif remaining_days <= 20
			"warning text-dark"
		else
			"success"
		end
	end

	def status_color
		if @group_remit.pending? || @group_remit.for_renewal? || @group_remit.under_review?
			"var(--bs-yellow)"
		elsif @group_remit.active?
			"var(--bs-green)"
		elsif @group_remit.expired?
			"var(--bs-red)"
		elsif @group_remit.for_payment?
			"var(--bs-blue)"
		end
	end



	def link_to_show
		case @group_remit.class.name
		when "LoanInsurance::GroupRemit"
			loan_insurance_group_remit_path(@group_remit)
		else
			group_remit_path(@group_remit)
		end
	end

end
