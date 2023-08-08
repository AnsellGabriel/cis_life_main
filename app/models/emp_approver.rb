class EmpApprover < ApplicationRecord
  belongs_to :employee
  belongs_to :approver, class_name: "Employee"
end
