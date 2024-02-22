# # life underwriting
# [
#   {first_name: 'Jackie', middle_name: 'P.', last_name: 'Ballena', email: "head_analyst@gmail.com", birthdate: '1996-09-03', rank: 3},
#   {first_name: 'Glady', middle_name: 'J.', last_name: 'De Vera', email: "senior_analyst@gmail.com", birthdate: '1996-09-03', rank: 2},
#   {first_name: 'Rulian', middle_name: 'P.', last_name: 'Rong', email: "analyst@gmail.com", birthdate: '1996-09-03', rank: 1}
# ].each do |employee|
#   emp = Employee.create!(employee.except(:rank, :email).merge(department_id: 17))
#   User.create!(email: employee[:email], password: 'Password123!', userable: emp, approved: 1, rank: employee[:rank])
# end

# puts 'Life underwriters created'

# EmpApprover.create!(employee_id: 3, approver_id: 2)
# EmpAgreement.create!(employee_id: 3, agreement_id: 24)
# EmpAgreement.create!(employee_id: 3, agreement_id: 25)
