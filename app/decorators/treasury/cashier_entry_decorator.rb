class Treasury::CashierEntryDecorator < ApplicationDecorator
  delegate_all

  # add Rails route helper
  include Rails.application.routes.url_helpers



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
       when "pending" then "badge bg-warning text-dark"
       when "cancelled" then "badge bg-danger"
       when "posted" then "badge bg-success"
    end
   end

  def show_path(origin: nil)
    if remittance?
      payment_entry_path(object.entriable, object, origin: origin)
    else
      treasury_cashier_entry_path(object, origin: origin)
    end
  end

  def edit_path
    if remittance?
      edit_payment_entry_path(object.entriable, object)
    else
      edit_treasury_cashier_entry_path(object)
    end
  end

  def cancel_path
    if remittance?
      cancel_payment_entry_path(object.entriable, object)
    else
      cancel_treasury_cashier_entry_path(object)
    end
  end

  private

  def remittance?
    object.entriable_type == 'Payment'
  end

end
