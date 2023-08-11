module EmpAgreementsHelper
  def ea_badge_pill(val)
    case val
      when true then content_tag :span, "ACTIVE", class: "badge rounded-pill bg-success"
      when false then content_tag :span, "INACTIVE", class: "badge rounded-pill bg-danger"
    end
  end

  def cat_type(val)
    case val
    when "main_approver" then content_tag :p, "MAIN", class: "lead text-primary"
    when "sub_approver" then content_tag :p, "SUB", class: "lead text-secondary"
    end
  end

end
