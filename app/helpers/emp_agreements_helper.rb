module EmpAgreementsHelper
  def ea_badge_pill(val)
    case val
      when true then content_tag :span, "ACTIVE", class: "badge rounded-pill bg-success"
      when false then content_tag :span, "INACTIVE", class: "badge rounded-pill bg-danger"
    end
  end

end
