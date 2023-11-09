class PaymentDecorator < Draper::Decorator
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
    when 'for_review'
      'text-primary'
    when 'approved'
      'text-success'
    when 'rejected'
      'text-danger'
    end
  end
end
