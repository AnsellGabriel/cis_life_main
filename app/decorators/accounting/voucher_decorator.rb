class Accounting::VoucherDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def audit_badge
    case object.audit
      when "for_audit", "pending_audit" then "badge bg-warning text-dark"
      when "approved" then "badge bg-success"
      when "pending" then "badge bg-danger"
    end
  end

  def status_badge
    case object.status
      when "pending", "for_approval" then "badge bg-warning text-dark"
      when "posted" then "badge bg-success"
      when "cancelled" then "badge bg-danger"
    end
  end

  def payout_status_badge
    case object.payout_status
      when "pending_payout" then "badge bg-warning text-dark"
      when "paid" then "badge bg-success"
    end
  end

  def audit_text
    object.audit.titleize
  end
end
