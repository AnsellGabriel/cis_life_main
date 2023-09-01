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

	def is_pending_or_renewal?
		@group_remit.pending? || @group_remit.for_renewal?
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

	def status_badge
		case @group_remit.status
		when "pending", "for_renewal", "under_review"
			"badge bg-warning text-dark"
		when "active"
			"badge bg-success"
		when "expired", "with_pending_members"
			"badge bg-danger"
		when "for_payment", "payment_verification"
			"badge bg-primary"
		end
	end
	
	def status_text
		case @group_remit.status
		when "pending"
			"Pending"
		when "active"
			"Active"
		when "expired"
			"Expired"
		when "for_renewal"
			"For renewal"
		when "under_review"
			"Under review"
		when "for_payment"
			"For payment"
		when "payment_verification"
			"For payment verification"
		when "with_pending_members"
			"Pending members"
		end
	end

	def status_mappings
		status_mappings = {
			for_review: { label: "For Review", class: "btn-outline-secondary" },
			approved: { label: "Approved", class: "btn-success" },
			pending: { label: "Pending", class: "btn-secondary" },
			denied: { label: "Denied", class: "btn-danger" }
		} 

	 	status_mappings = status_mappings.merge(for_reconsideration: {label: 'Request', class: 'btn-warning'}) if @group_remit.agreement.reconsiderable? 

		status_mappings
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