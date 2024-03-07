module ApplicationHelper
  include Pagy::Frontend

  def to_currency(amount)
    number_to_currency(amount, locale: :ph)
  end

  def psheet_currency(amount)
    number_with_delimiter(amount, precision: 2)
  end

  def to_curr(amount)
    number_to_currency(amount, unit: "")
  end

  def to_longdate(date)
    date.strftime("%B %d, %Y")
  end

  def to_shortdate(date)
    date&.strftime("%b %d, %Y")
  end
  def start_month(val)
    val.beginning_of_month
  end

  def end_month(val)
    val.end_of_month
  end

  def start_week(val)
    val.beginning_of_week
  end

  def end_week(val)
    val.end_of_week
  end

  def num_delimit(num)
    number_with_delimiter(num)
  end

  def to_percent(num)
    number_to_percentage(num, precision: 1)
  end

  def contestable_age(min, max)
    min == 0 && max == 0 ? "" : "(#{min} to #{max} years old)"
  end

  def extract_from_substring(original_string, substring)
    index = original_string.index(substring)
    index ? original_string[index..-1] : nil
  end

  def contestable_period(period, type)
    period <= 0 ? "Waived Contestability" : "#{pluralize(sprintf('%g', period), type)}"
  end

  def nel_nml(amount = nil)
    amount == 0 ? "None" : "#{to_currency(amount)}"
  end

  def plan_bg(id)
    case id
      when 1 then "bg-primary px-2" # LPPI
      when 2 then "bg-warning px-2" # GYRT
      when 3 then "bg-success px-2" # YES
      when 4 then "bg-danger px-2" # SII
      when 5 then "bg-info px-2" # GBLISS
    end
  end

  def health_dec_answer(id, val, type)
    # if (1..2).include?(id)
    if id == true && type == "HealthDec"
      case val
        when "true" then content_tag(:small, "Yes", class: "text-success")
        when "false" then content_tag(:small, "No", class: "text-danger")
      end
    else
      case val
        when "true" then content_tag(:small, "Yes", class: "text-danger")
        when "false" then content_tag(:small, "No", class: "text-success")
      end
    end
  end

  def insurance_status(val)
    case val
      when "for_review" then content_tag(:span, "For Review", class: "lead text-muted")
      when "pending" then content_tag(:span, "Pending", class: "lead text-dark")
      when "approved" then content_tag(:span, "Approved", class: "lead text-success")
      when "denied" then content_tag(:span, "Denied", class: "lead text-danger")
      when "for_reconsideration" then content_tag(:span, "For Reconsideration", class: "lead text-primary")
    end
  end

  def batch_status(val)
    case val
      when "recent" then content_tag(:span, "NEW", class: "badge bg-primary")
      when "transferred" then content_tag(:span, "TRANSFERRED", class: "badge bg-secondary")
      when "renewal" then content_tag(:span, "RENEWAL", class: "badge bg-success")
      when "reinstated" then content_tag(:span, "REINSTATED", class: "badge bg-warning")
      when "for_reconsideration" then content_tag(:span, "FOR RECONSIDER", class: "badge bg-info")
      when "reloan" then content_tag(:span, "RELOAN", class: "badge bg-warning text-dark")
      when "terminated" then content_tag(:span, "TERMINATED", class: "badge bg-danger")
    end
  end

  def process_dates(type, val)
    content_tag :small do
      "#{type}: #{content_tag(:b, val)}".html_safe
    end
  end

  def process_premiums(type, val)
    # content_tag :span, class: "badge text-dark"  do
    # 	"#{type}: #{content_tag(:b, to_currency(val))}".html_safe
    # end
    content_tag :span, "#{type}: #{to_currency(val)}", class: "badge text-dark text-start"
  end

  def process_premiums_class(val)
    if val == "Net Prem"
      "badge text-success text-start"
    elsif val == "Premium"
      "badge text-dark text-start"
    else
      "badge text-danger text-start"
    end
  end

  def process_status(val)
    case val
      when "pending" then content_tag(:span, "Pending", class: "text-secondary")
      when "approved" then content_tag(:span, "Approved", class: "text-success")
      when "denied" then content_tag(:span, "Denied", class: "text-danger")
      when "for_process" then content_tag(:span, "For Process", class: "text-dark")
      when "for_head_approval" then content_tag(:span, "For Head Approval", class: "text-secondary")
      when "for_vp_approval" then content_tag(:span, "For VP Approval", class: "text-secondary")
      when "reprocess" then content_tag(:span, "Reprocessed", class: "text-success")
      when "reprocess_request" then content_tag(:span, "Request for Reprocess", class: "text-secondary")
      when "reprocess_approved" then content_tag(:span, "Request for Reprocess Approved", class: "text-warning")
      when "reconsiderations_processed" then content_tag(:span, "Reconsiderations Processed", class: "text-warning")
      when "reassess" then content_tag(:span, "For Re-assessment", class: "text-primary")
    end
  end

  def remarks_status(val)
    case val
      when "pending" then content_tag(:span, "Pending", class: "badge rounded-pill bg-secondary")
      when "approved" then content_tag(:span, "Approved", class: "badge rounded-pill bg-success")
      when "denied" then content_tag(:span, "Denied", class: "badge rounded-pill bg-danger")
      when "reassess" then content_tag(:span, "For Re-assessment", class: "badge rounded-pill bg-primary")
      when "for_head_approval" then content_tag(:span, "For Head Approval", class: "badge rounded-pill bg-secondary")
      when "for_vp_approval" then content_tag(:span, "For VP Approval", class: "badge rounded-pill bg-secondary")
      when "reprocess" then content_tag(:span, "Reprocessed", class: "badge rounded-pill bg-warning")
      when "reprocess_request" then content_tag(:span, "For Reprocess Request", class: "badge rounded-pill bg-warning")
      when "reprocess_approved" then content_tag(:span, "Reprocess Request Approved", class: "badge rounded-pill bg-success")
      when "rejected" then content_tag(:span, "Rejected", class: "badge rounded-pill bg-danger")
    end
  end

  def insured_type(val, name)
    case val
      when 1 then content_tag(:span, name, class: "badge rounded-pill bg-primary")
      when 2, 3, 4, 5 then content_tag(:span, name, class: "badge rounded-pill bg-info")
      when 6 then content_tag(:span, name, class: "badge rounded-pill bg-success")
      when 7 then content_tag(:span, name, class: "badge rounded-pill bg-success")
      when 8 then content_tag(:span, name, class: "badge rounded-pill bg-warning")
      when 9 then content_tag(:span, name, class: "badge rounded-pill bg-danger")
    end
  end

  def batch_rem_status(val)
    case val
      when "pending" then content_tag(:span, "Pending", class: "badge rounded-pill bg-secondary")
      when "denied" then content_tag(:span, "Denied", class: "badge rounded-pill bg-danger")
      when "md_reco" then content_tag(:span, "M.D Recommendation", class: "badge rounded-pill bg-warning")
      when "request" then content_tag(:span, "Requesting for reconsideration", class: "badge rounded-pill bg-warning text-dark")
      when "terminated" then content_tag(:span, "Terminated", class: "badge rounded-pill bg-danger")

    end
  end

  def aria_sel(index)
    if index == 0 then
      "true"
    else
      "false"
    end

  end

  def approved_status(val)
    if val == true
      content_tag(:p, "ACTIVE", class: "badge rounded-pill bg-success mb-0 float-end")
    else
      content_tag(:p, "INACTIVE", class: "badge rounded-pill bg-danger mb-0 float-end")
    end
  end

  def badge_pill(val)
    case val
      when true then content_tag :span, "ACTIVE", class: "badge rounded-pill bg-success"
      when false then content_tag :span, "INACTIVE", class: "badge rounded-pill bg-danger"
    end
  end

  def coop_user?(current_user)
    current_user.userable_type == "CoopUser"
  end

  def mis_user?(current_user)
    current_user.userable_type == "Employee" && current_user.userable.department_id == 15
  end

  def agent_user?(current_user)
    current_user.userable_type == "Agent"
  end

  def nav_header(current_user)
    user_type = current_user.userable_type

    if user_type == "CoopUser"
      current_user.userable.coop_branch.name
    elsif user_type == "Employee"

      case current_user.userable.department_id
      when 15 then "MANAGEMENT INFORMATION SYSTEM"
      when 11 then "ACCOUNTING"
      when 27 then "AUDIT"
      end

    end
  end

end
