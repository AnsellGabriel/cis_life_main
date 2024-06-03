class EmpAgreement < ApplicationRecord
  attr_accessor :old_emp_agreement
  # attr_accessor :employee_id

  belongs_to :employee
  belongs_to :agreement
  belongs_to :team
  # belongs_to :approver, class_name: "Employee"

  enum category_type: {
    main_approver: 0,
    sub_approver: 1
  }

end
