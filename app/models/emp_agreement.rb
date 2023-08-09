class EmpAgreement < ApplicationRecord
  attr_accessor :old_emp_agreement

  belongs_to :employee
  belongs_to :agreement
  # belongs_to :approver, class_name: "Employee"
end
