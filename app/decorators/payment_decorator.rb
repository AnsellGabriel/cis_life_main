class PaymentDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def receiptable?
    entries = object.entries

    (entries.empty? or entries.last&.cancelled?) and !object.rejected?
  end

  def status_badge
    case object.status
       when "pending", "for_renewal", "under_review", "for_payment", "payment_verification", "reupload_payment", "for_review" then "badge bg-warning text-dark"
       when "expired", "with_pending_members", "rejected" then "badge bg-danger"
       when "paid", "approved" then "badge bg-success"
    end
   end
end
