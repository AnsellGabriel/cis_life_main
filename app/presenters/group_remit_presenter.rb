class GroupRemitPresenter
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

	def is_expired?
		@group_remit.expired?
	end

	def is_for_payment?
		@group_remit.for_payment?
	end

	def remaining_days
		(@group_remit.expiry_date - Date.today).to_i
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
		when "expired"
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
		end
	end

end