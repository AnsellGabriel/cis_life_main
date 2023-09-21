class BatchDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def status_color
		case object.insurance_status
		when 'for_review' then 'text-warning'
		when 'approved' then 'text-success'
		when 'pending' then 'text-secondary'
		when 'denied' then 'text-danger'
		when 'terminated' then 'text-danger'
		end
	end

  def insurance_badge
    if object.approved?
      'primary'
    elsif object.denied? or object.terminated? or object.expired?
      'danger'
    else
      'warning text-dark'
    end
  end

  def status_badge
    if object.recent?
      'primary'
    else
      'warning text-dark'
    end
  end

end
