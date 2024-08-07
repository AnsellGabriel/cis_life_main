class GroupRemitDecorator < Draper::Decorator
  include Rails.application.routes.url_helpers
  delegate_all

  def is_remittance?
    object.type == "Remittance"
   end

  def is_pending_or_renewal?
    object.pending? || object.for_renewal?
   end

  def is_for_renewal?
    object.for_renewal?
  end

  def is_none_anniversary?
    object.agreement.anniversary_type.downcase == "12 months" || object.agreement.anniversary_type.nil?
  end

  def is_single_anniversary?
    object.agreement.anniversary_type.downcase == "single"
  end

  def is_multiple_anniversary?
    object.agreement.anniversary_type.downcase == "multiple"
  end

  def is_batch_remit?
    object.type == "BatchRemit"
  end

  def is_pending?
    object.pending?
  end

  def is_expired?
    object.expired?
  end

  def is_for_payment?
    object.for_payment?
  end

  def is_for_reupload?
    object.reupload_payment?
  end

  def remaining_days
    remaining_days = (object.expiry_date - Date.today).to_i
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
    if object.pending? || object.for_renewal? || object.under_review? || object.for_payment?
      "var(--bs-yellow)"
    elsif object.paid?
      "var(--bs-green)"
    elsif object.expired?
      "var(--bs-red)"
    end
  end

  def refund_badge
    if object.unrefunded?
      "badge bg-danger"
    elsif object.refunded?
      "badge bg-success"
    else
      "badge bg-warning text-dark"
    end
  end


  def link_to_show
    case object.class.name
    when "LoanInsurance::GroupRemit"
      loan_insurance_group_remit_path(object)
    else
      group_remit_path(object)
    end
  end

  def status_badge
    case object.status
       when "pending", "for_renewal", "under_review", "for_payment", "payment_verification", "reupload_payment" then "badge bg-warning text-dark"
       when "expired", "with_pending_members" then "badge bg-danger"
       when "paid" then "badge bg-success"
    end
   end

  def status_text
    object.status.titleize
  end

  def refund_text
    object.refund_status.titleize
  end

  def status_mappings
    status_mappings = {
      for_review: { label: "For Review", class: "btn-outline-secondary" },
      approved: { label: "Approved", class: "btn-success" },
      pending: { label: "Pending", class: "btn-secondary" },
      denied: { label: "Denied", class: "btn-danger" }
    }

    status_mappings = status_mappings.merge(for_reconsideration: {label: "Request", class: "btn-warning"}) if object.agreement.reconsiderable?

    status_mappings
   end

  def complete_health_decs?
    object.batches.where(status: [:recent, :reinstated]).where.missing(:batch_health_decs).where.not(loan_amount: 0..agreement.nel).empty? || object.mis_entry?
   end
end
