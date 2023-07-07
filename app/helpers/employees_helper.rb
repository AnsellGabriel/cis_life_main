module EmployeesHelper

  def emp_name(head, name)
    if head == true 
      content_tag(:span, name, class: "lead fw-bold")
    else
      content_tag(:span, name, class: "lead")
    end
  end
  
end
