class GroupRemitPresenter
	def initialize(group_remit)
		@group_remit = group_remit
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
		if @group_remit.pending? || @group_remit.for_renewal?
			"var(--bs-yellow)"
		elsif @group_remit.active?
			"var(--bs-green)"
		elsif @group_remit.expired?
			"var(--bs-red)"
		elsif @group_remit.under_review?
			"var(--bs-yellow)"
		elsif @group_remit.for_payment?
			"var(--bs-blue)"
		end
	end

	def status_badge
		case @group_remit.status
		when "pending"
			"badge bg-warning text-dark"
		when "active"
			"badge bg-success"
		when "expired"
			"badge bg-danger"
		when "for_renewal"
			"badge bg-warning text-dark"
		when "under_review"
			"badge bg-warning text-dark"
		when "for_payment"
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
		end
	end

end