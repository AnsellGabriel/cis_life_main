class GroupRemitDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def status_badge
    case object.status
		when "pending", "for_renewal", "under_review"
			"badge bg-warning text-dark"
		when "expired", "with_pending_members"
			"badge bg-danger"
		when "for_payment", "payment_verification", "paid"
			"badge bg-primary"
		end
	end

  def status_text
    object.status.titleize
  end

  def is_pending_or_renewal?
		object.pending? || object.for_renewal?
	end

  def status_mappings
		status_mappings = {
			for_review: { label: "For Review", class: "btn-outline-secondary" },
			approved: { label: "Approved", class: "btn-success" },
			pending: { label: "Pending", class: "btn-secondary" },
			denied: { label: "Denied", class: "btn-danger" }
		}

	 	status_mappings = status_mappings.merge(for_reconsideration: {label: 'Request', class: 'btn-warning'}) if object.agreement.reconsiderable?

		status_mappings
	end

  def complete_health_decs?
		object.batches.where(status: :recent).where.missing(:batch_health_decs).empty?
	end
end
