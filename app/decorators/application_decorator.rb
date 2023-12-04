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
    when "approved", "posted", "voucher_generated" then "success"
    when "pending", "for_review" then "warning"
    when "rejected", "terminated", "cancelled" then "danger"
    end
  end
end
