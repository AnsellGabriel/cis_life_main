# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# spreadsheet = Roo::Spreadsheet.open("./db/uploads/benefits.xlsx")

# (2..spreadsheet.last_row).each do |row|
#     benefit = Benefit.find_or_initialize_by(name: spreadsheet.cell(row, 'A'))
#     benefit.acronym = spreadsheet.cell(row,'B')
#     puts "#{benefit.name}" if benefit.save!
# end

# spreadsheet = Roo::Spreadsheet.open("./db/uploads/department.xlsx")

# (2..spreadsheet.last_row).each do |row|
#     dep = Department.find_or_initialize_by(name: spreadsheet.cell(row, 'A'))
#     dep.description = spreadsheet.cell(row,'B')
#     puts "#{dep.name}" if dep.save!
# end


# spreadsheet = Roo::Spreadsheet.open("./db/uploads/department.xlsx")
# (2..spreadsheet.last_row).each do |row|
#     dep = CoopType.find_or_initialize_by(name: spreadsheet.cell(row, 'C'))
#     dep.description = spreadsheet.cell(row,'D')
#     puts "#{dep.name}" if dep.save!
# end
# # Cooperatives
# cooperatives_spreadsheet = Roo::Spreadsheet.open("./db/uploads/Operating-Coops.xlsx")
# (5..100).each do |row|
#     spreadsheet = cooperatives_spreadsheet
#     Cooperative.find_or_create_by!(
#         registration_number: spreadsheet.cell(row, 'A'), 
#         name: spreadsheet.cell(row, 'B'), 
#         region: spreadsheet.cell(row, 'C'), 
#         province: spreadsheet.cell(row, 'D'), 
#         municipality: spreadsheet.cell(row, 'E'), 
#         street: spreadsheet.cell(row, 'F'), 
#         cooperative_type: spreadsheet.cell(row, 'H'),
#         email: spreadsheet.cell(row, 'K'), 
#         contact_number: spreadsheet.cell(row, 'J'),
#     )
# end
# # Coop Branches
# 10.times do |i|
#     CoopBranch.create!(name: "Branch #{i+1}", cooperative_id: 1, region: "Region 1", province: "Province 1", municipality: "Municipality 1", barangay: "Barangay 1", street: "Street 1", contact_details: "09123456789")
# end

# # Coop User
# CoopUser.create!(first_name: 'Lian', last_name: 'Postrano', middle_name: 'Elliot', birthdate: FFaker::Time.date, mobile_number: '09948423385', coop_branch_id: 1, cooperative_id: 1)
# User.create!(email: 'coop@gmail.com', password: 'password', password_confirmation: 'password', userable_id: 1, userable_type: 'CoopUser')

# spreadsheet = Roo::Spreadsheet.open("./db/uploads/addresses.xlsx")
# (2..spreadsheet.last_row).each do |row|
#         reg = GeoRegion.find_or_initialize_by(name: spreadsheet.cell(row, 'A').strip)
#         puts "#{reg.name}" if reg.save!
    
#         pro = GeoProvince.find_or_initialize_by(name: spreadsheet.cell(row, 'B').strip)
#         pro.geo_region_id = reg.id
#         puts "#{pro.name}" if pro.save!
        
#         mun = GeoMunicipality.find_or_initialize_by(name: spreadsheet.cell(row, 'C').strip)
#         mun.geo_region_id = reg.id
#         mun.geo_province_id = pro.id
#         puts "#{mun.name}" if mun.save!
        
#         bar = GeoBarangay.find_or_initialize_by(name: spreadsheet.cell(row, 'D').strip)
#         bar.geo_region_id = reg.id
#         bar.geo_province_id = pro.id
#         bar.geo_municipality_id = mun.id
#         bar.psgc_code = spreadsheet.cell(row, 'E')
#         puts "#{bar.name}" if bar.save!
#     end

# Admin
# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# # Cooperative
# cooperatives_spreadsheet = Roo::Spreadsheet.open("/Users/macbookair/Desktop/cis_data/Operating-Coops.xlsx")
# (5..100).each do |row|
#     spreadsheet = cooperatives_spreadsheet
#     Cooperative.find_or_create_by!(
#         # registration_number: spreadsheet.cell(row, 'A'), 
#         name: spreadsheet.cell(row, 'B'), 
#         # region: spreadsheet.cell(row, 'C'), 
#         # province: spreadsheet.cell(row, 'D'), 
#         # municipality: spreadsheet.cell(row, 'E'), 
#         # street: spreadsheet.cell(row, 'F'), 
#         # cooperative_type: spreadsheet.cell(row, 'H'),
#         email: spreadsheet.cell(row, 'K'), 
#         # contact_number: spreadsheet.cell(row, 'J'),
#     )
# end

# Proposal
# Proposal.create!(proposal_no: 'PROP-00001' ,cooperative_id: 1, coop_sf: 12.5, agent_sf: 4.5, ave_age: 50, minimum_participation: 3)

# # AgentGroup
# AgentGroup.create!(name: 'Marketing', description: 'Marketing Group')

# # Agent
# Agent.create!(first_name: 'Rullian', middle_name: 'Postrano', last_name: 'Rong', agent_group_id: 1)

# # Plan
# Plan.create!(name: 'GYRT-Basic', description: 'Plan 1 description', gyrt_type: 'basic', acronym: 'GYRT')
# Plan.create!(name: 'GYRT-Family', description: 'Plan 2 description', gyrt_type: 'family', acronym: 'GYRTF')
# Plan.create!(name: 'GYRT-Basic Ranking', description: 'Plan 3 description', gyrt_type: 'basic', acronym: 'GYRTBR')
# Plan.create!(name: 'GYRT-Family Ranking', description: 'Plan 4 description', gyrt_type: 'family', acronym: 'GYRTFR')


# Benefit
# Benefit.create!(name: 'Life', description: 'Benefit 1 description', acronym: 'LIFE')
# Benefit.create!(name: 'Accidental Death & Dismemberment', description: 'Benefit 2 description', acronym: 'ADD')


# # GYRT Basic Single Anniversary  
# Agreement.create!(proposal_id: 1, moa_no: 'GYRT Basic - Single Anniversary', plan_id: 1, agent_id: 1, cooperative_id: 1, anniversary_type: 'single')
# AgreementBenefit.create!(agreement_id: 1, proposal_id: 1, name: 'Agreement Benefit principal', min_age: 18, max_age: 65, insured_type: 1)
# ProductBenefit.create!(coverage_amount: 150000,benefit_id: 1, agreement_benefit_id: 1, premium: 200)
# ProductBenefit.create!(coverage_amount: 100000,benefit_id: 2, agreement_benefit_id: 1, premium: 150)
# Anniversary.create!(agreement_id: 1, name: 'May 31', anniversary_date: '2023/05/31')

# # GYRT Family Multiple Anniversary
# Agreement.create!(proposal_id: 1, moa_no: 'GYRT Family - No Anniversary date', plan_id: 2, agent_id: 1, cooperative_id: 1, anniversary_type: 'none')
# ### Principal
# AgreementBenefit.create!(agreement_id: 2, proposal_id: 1, name: 'Agreement Benefit principal', min_age: 18, max_age: 65, insured_type: 1)
# ProductBenefit.create!(coverage_amount: 150000,benefit_id: 1, agreement_benefit_id: 2, premium: 200)
# ### Dependent - Spouse
# AgreementBenefit.create!(agreement_id: 2, proposal_id: 1, name: 'Agreement Benefit dependent', min_age: 18, max_age: 65, insured_type: 2)
# ProductBenefit.create!(coverage_amount: 75000,benefit_id: 1, agreement_benefit_id: 3, premium: 100)
# ### Dependent - Parent
# AgreementBenefit.create!(agreement_id: 2, proposal_id: 1, name: 'Agreement Benefit principal', min_age: 18, max_age: 65, insured_type: 3)
# ProductBenefit.create!(coverage_amount: 100000,benefit_id: 1, agreement_benefit_id: 4, premium: 150)
# ### Dependent - Child
# AgreementBenefit.create!(agreement_id: 2, proposal_id: 1, name: 'Agreement Benefit principal', min_age: 18, max_age: 65, insured_type: 4)
# ProductBenefit.create!(coverage_amount: 50000,benefit_id: 1, agreement_benefit_id: 5, premium: 50)
# ### Dependent - Sibling
# AgreementBenefit.create!(agreement_id: 2, proposal_id: 1, name: 'Agreement Benefit principal', min_age: 18, max_age: 65, insured_type: 5)
# ProductBenefit.create!(coverage_amount: 75000,benefit_id: 1, agreement_benefit_id: 6, premium: 100)

# # GYRT Basic No Anniversary
# Agreement.create!(proposal_id: 1, moa_no: 'GYRT-MOA-0002', description: 'Agreement with no anniversary type', plan_id: 1, agent_id: 1, cooperative_id: 1, anniversary_type: 'none')
# AgreementBenefit.create!(agreement_id: 3, proposal_id: 1, name: 'Agreement Benefit principal', min_age: 18, max_age: 65, insured_type: 1)
# ProductBenefit.create!(coverage_amount: 150000,benefit_id: 1, agreement_benefit_id: 7, premium: 200)
# ProductBenefit.create!(coverage_amount: 100000,benefit_id: 2, agreement_benefit_id: 7, premium: 150)

# # GYRT Ranking - Basic
# Agreement.create!(proposal_id: 1, moa_no: 'GYRT Ranking - Multiple Anniversary', plan_id: 3, agent_id: 1, cooperative_id: 1, anniversary_type: 'multiple')

# AgreementBenefit.create!(agreement_id: 3, proposal_id: 1, name: 'Agreement Benefit BOD', min_age: 18, max_age: 65, insured_type: 6)
# AgreementBenefit.create!(agreement_id: 3, proposal_id: 1, name: 'Agreement Benefit SO', min_age: 18, max_age: 65, insured_type: 7)
# AgreementBenefit.create!(agreement_id: 3, proposal_id: 1, name: 'Agreement Benefit JO', min_age: 18, max_age: 65, insured_type: 8)
# AgreementBenefit.create!(agreement_id: 3, proposal_id: 1, name: 'Agreement Benefit Rank & File', min_age: 18, max_age: 65, insured_type: 9)

# ProductBenefit.create!(coverage_amount: 500000,benefit_id: 1, agreement_benefit_id: 7, premium: 500)
# ProductBenefit.create!(coverage_amount: 350000,benefit_id: 1, agreement_benefit_id: 8, premium: 350)
# ProductBenefit.create!(coverage_amount: 250000,benefit_id: 1, agreement_benefit_id: 9, premium: 250)
# ProductBenefit.create!(coverage_amount: 150000,benefit_id: 1, agreement_benefit_id: 10, premium: 150)

# Anniversary.create!(agreement_id: 3, name: 'March 18', anniversary_date: '2023/03/18')
# Anniversary.create!(agreement_id: 3, name: 'February 25', anniversary_date: '2023/02/25')
# Anniversary.create!(agreement_id: 3, name: 'January 30', anniversary_date: '2023/01/30')

# # CoopBranch of Coop 1
# 10.times do |i|
#     CoopBranch.create!(name: "Branch #{i+1}", cooperative_id: 1, region: "Region 1", province: "Province 1", municipality: "Municipality 1", barangay: "Barangay 1", street: "Street 1", contact_details: "09123456789")
# end

# # Coop User
# CoopUser.create!(first_name: 'Lian', last_name: 'Postrano', middle_name: 'Elliot', birthdate: FFaker::Time.date, mobile_number: '09948423385', coop_branch_id: 1, cooperative_id: 1)
# User.create!(email: 'coop@gmail.com', password: 'password', password_confirmation: 'password',  approved: true, userable_id: 1, userable_type: 'CoopUser')


# Employees
spreadsheet = Roo::Spreadsheet.open('./db/uploads/EMPLOYEE-MASTERLIST.xlsx')
(2..spreadsheet.last_row).each do |emp|
  
  user_name = (spreadsheet.cell(emp, "C")[0] + spreadsheet.cell(emp, "D")[0] + spreadsheet.cell(emp, "B")).downcase.gsub(/\s+/, "")
  email = "#{user_name}@1cisp.coop"

  dept = Department.find_or_initialize_by(name: spreadsheet.cell(emp, "F"))
  dept.description = ""
  puts "#{dept.name} - saved" if dept.save!

  employee = Employee.find_or_initialize_by(
    last_name: spreadsheet.cell(emp, "B"),
    first_name: spreadsheet.cell(emp, "C"),
    middle_name: spreadsheet.cell(emp, "D")
  )
  employee.department_id = dept.id
  employee.birthdate = ""
  employee.designation = spreadsheet.cell(emp, "G")
  employee.employee_number = spreadsheet.cell(emp, "A")
  employee.mobile_number = ""
  puts "#{employee.last_name} - DONE!" if employee.save!
  
  user = User.find_or_initialize_by(email: email)
  user.password = user_name
  user.userable = employee
  user.admin = spreadsheet.cell(emp, "H")
  user.approved = true
  puts "#{user.email} - DONE!" if user.save!
end