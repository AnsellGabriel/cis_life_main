module EmployeesHelper

  def emp_name(head, name)
    if head == true 
      content_tag(:span, name, class: "lead fw-bold")
    else
      content_tag(:span, name, class: "lead")
    end
  end

  def authority_level(name)
    case name
    when "rank_and_file" then content_tag(:span, "Rank & File", class: "fw-italic")
    when "analyst" then content_tag(:span, "Underwriting Analyst", class: "fw-italic")
    when "head" then content_tag(:span, "Dept. Head", class: "fw-italic")
    when "senior_officer" then content_tag(:span, "Senior Officer", class: "fw-italic")
    end
  end
  
end
