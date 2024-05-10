class Accounting::VoucherRequestDecorator < ApplicationDecorator
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
      when "pending", "voucher_generated" then "badge bg-warning text-dark"
      when "posted" then "badge bg-success"
      when "cancelled" then "badge bg-danger"
    end
  end
end
