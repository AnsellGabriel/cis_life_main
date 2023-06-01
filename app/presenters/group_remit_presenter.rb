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
		if @group_remit.pending?
			"var(--bs-yellow)"
		elsif @group_remit.active?
			"var(--bs-green)"
		elsif @group_remit.expired?
			"var(--bs-red)"
		end
	end

end