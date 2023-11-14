class ApplicationDecorator < Draper::Decorator
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
    case object.status
    when "approved" then "success"
    when "pending" then "warning"
    when "rejected" then "danger"
    when "terminated" then "danger"
    when "cancelled" then "danger"
    when "for_review" then "warning"
    end
  end
end
