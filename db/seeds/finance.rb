# # treasury
# treasurer = Employee.create!(first_name: 'Rulian', middle_name: 'P.', last_name: 'Rong', birthdate: '1996-09-03', department_id: 26)
# User.create!(email: "treasurer@gmail.com",  password: 'Password123!', userable: treasurer, approved: 1)
# Treasury::Account.create!(name: 'MetroBank', account_type: 1, is_check_account: true, )

# puts 'Treasurer account created'

# [
#   'MetroBank',
#   'Service Fee - LPPI',
#   'Service Fee - GYRT',
#   'Premium Income - LPPI',
#   'Premium Income - GYRT',
#   'Claims'
# ].each do |account|
#   Treasury::Account.create!(name: account, account_type: 1, is_check_account: false)
# end

# # accounting
# accountant = Employee.create!(first_name: 'Rulian', middle_name: 'P.', last_name: 'Rong', birthdate: '1996-09-03', department_id: 11)
# User.create!(email: "accountant@gmail.com",  password: 'Password123!', userable: accountant, approved: 1)

# puts 'Accountant created'

# # accounting
# auditor = Employee.create!(first_name: 'Rulian', middle_name: 'P.', last_name: 'Rong', birthdate: '1996-09-03', department_id: 27)
# User.create!(email: "auditor@gmail.com",  password: 'Password123!', userable: auditor, approved: 1)
