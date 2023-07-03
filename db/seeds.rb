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

# # Cooperatives

# # Admin
# # AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# # Cooperative
# cooperatives_spreadsheet = Roo::Spreadsheet.open("/Users/macbookair/Desktop/cis_data/Operating-Coops.xlsx")
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
# Benefit.create!(name: 'Life', description: 'Benefit 1 description', abbreviation: 'LIFE')
# Benefit.create!(name: 'Accidental Death & Dismemberment', description: 'Benefit 2 description', abbreviation: 'ADD')


# # GYRT Basic Single Anniversary  
# Agreement.create!(proposal_id: 1, moa_no: 'GYRT Basic - Single Anniversary', description: 'Agreement with a single anniversary type', plan_id: 1, agent_id: 1, cooperative_id: 1, anniversary_type: 'single')
# AgreementBenefit.create!(agreement_id: 1, proposal_id: 1, name: 'Agreement Benefit principal', min_age: 18, max_age: 65, insured_type: 1)
# ProductBenefit.create!(coverage_amount: 150000,benefit_id: 1, agreement_benefit_id: 1, premium: 200)
# ProductBenefit.create!(coverage_amount: 100000,benefit_id: 2, agreement_benefit_id: 1, premium: 150)
# Anniversary.create!(agreement_id: 1, name: 'May 31', anniversary_date: '2023/05/31')

# # GYRT Family Multiple Anniversary
# Agreement.create!(proposal_id: 1, moa_no: 'GYRT Family - No Anniversary date', description: 'Agreement with a mutiple anniversary type', plan_id: 2, agent_id: 1, cooperative_id: 1, anniversary_type: 'none')
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

# # # GYRT Basic No Anniversary
# # Agreement.create!(proposal_id: 1, moa_no: 'GYRT-MOA-0002', description: 'Agreement with no anniversary type', plan_id: 1, agent_id: 1, cooperative_id: 1, anniversary_type: 'none')
# # AgreementBenefit.create!(agreement_id: 3, proposal_id: 1, name: 'Agreement Benefit principal', min_age: 18, max_age: 65, insured_type: 1)
# # ProductBenefit.create!(coverage_amount: 150000,benefit_id: 1, agreement_benefit_id: 7, premium: 200)
# # ProductBenefit.create!(coverage_amount: 100000,benefit_id: 2, agreement_benefit_id: 7, premium: 150)

# # GYRT Ranking - Basic
# Agreement.create!(proposal_id: 1, moa_no: 'GYRT Ranking - Multiple Anniversary', description: 'Agreement with ranking type', plan_id: 3, agent_id: 1, cooperative_id: 1, anniversary_type: 'multiple')

# AgreementBenefit.create!(agreement_id: 3, proposal_id: 1, name: 'Agreement Benefit BOD', min_age: 18, max_age: 65, insured_type: 6)
# AgreementBenefit.create!(agreement_id: 3, proposal_id: 1, name: 'Agreement Benefit SO', min_age: 18, max_age: 65, insured_type: 7)
# AgreementBenefit.create!(agreement_id: 3, proposal_id: 1, name: 'Agreement Benefit JO', min_age: 18, max_age: 65, insured_type: 8)
# AgreementBenefit.create!(agreement_id: 3, proposal_id: 1, name: 'Agreement Benefit Rank & File', min_age: 18, max_age: 65, insured_type: 9)

#   dept = Department.find_or_initialize_by(name: spreadsheet.cell(emp, "F"))
#   dept.description = ""
#   puts "#{dept.name} - saved" if dept.save!

#   employee = Employee.find_or_initialize_by(
#     last_name: spreadsheet.cell(emp, "B"),
#     first_name: spreadsheet.cell(emp, "C"),
#     middle_name: spreadsheet.cell(emp, "D")
#   )
#   employee.department_id = dept.id
#   employee.birthdate = ""
#   employee.designation = spreadsheet.cell(emp, "G")
#   employee.employee_number = spreadsheet.cell(emp, "A")
#   employee.mobile_number = ""
#   puts "#{employee.last_name} - DONE!" if employee.save!
  
#   user = User.find_or_initialize_by(email: email)
#   user.password = user_name
#   user.userable = employee
#   user.admin = spreadsheet.cell(emp, "H")
#   user.approved = true
#   puts "#{user.email} - DONE!" if user.save!
# end
# =======
# # CoopBranch of Coop 1
# 10.times do |i|
#     CoopBranch.create!(name: "Branch #{i+1}", cooperative_id: 1, region: "Region 1", province: "Province 1", municipality: "Municipality 1", barangay: "Barangay 1", street: "Street 1", contact_details: "09123456789")
# end

# # Coop User
# CoopUser.create!(first_name: 'Lian', last_name: 'Postrano', middle_name: 'Elliot', birthdate: FFaker::Time.date, mobile_number: '09948423385', coop_branch_id: 1, cooperative_id: 1)
# User.create!(email: 'coop@gmail.com', password: 'password', password_confirmation: 'password',  approved: true, userable_id: 1, userable_type: 'CoopUser')

# >>>>>>>>> Temporary merge branch 2

# HealthDec.create!(question: "Do you drink alcohol?", active: true, with_details: true, valid_answer: false)
# HealthDecSubquestion.create!(question: "Please state whether beer, wine, or spirits; and your average daily consumption", health_dec_id: 6)

# JFC COOP Import
# coop = Cooperative.find_or_initialize_by(name: "Jollibee Foods Corporation Employees Multi-Purpose Cooperative")
# coop.region = "NCR"
# coop.province = 'Metro Manila'
# coop.municipality = 'Pasig City'
# coop.cooperative_type = 'Multi-Purpose'
# coop.street = 'Jollibee Plaza, Ortigas Center'
# coop.email = 'JFC@coop.com'
# coop.save!

# Coop User
# CoopUser.create!(first_name: 'Cherry', last_name: 'Gonzales', middle_name: 'P', birthdate: FFaker::Time.date, mobile_number: '09948423385', coop_branch_id: 32, cooperative_id: 97)
# User.create!(email: 'jfc@gmail.com', password: 'password', password_confirmation: 'password',  approved: true, userable_id: 1, userable_type: 'CoopUser')

#Agreement
# agreement = Agreement.create!(plan_id: 4, cooperative_id: 97, agent_id: 1, moa_no: "JFC-0001", contestability: 12, nel: 25000, nml: 5000000, anniversary_type: 'Single', transferred: 0, comm_type: "Gross Commission", entry_age_from: 18, entry_age_to: 65, exit_age: 80, proposal_id: 1)

# for Principal (name, insured_type)
# agreement = Agreement.find_by(id: 8)
# [
#   ['Option 1', 9
#   ],
#   ['Option 2', 9
#   ],
#   ['Option 3', 8
#   ],
#   ['Option 4', 7
#   ],
#   ['Option 5', 6
#   ]
# ].each do |ab|
#   agree_ben = AgreementBenefit.find_or_initialize_by(agreement_id: agreement.id, name: ab[0])
#   agree_ben.proposal_id = agreement.proposal_id
#   agree_ben.min_age = agreement.entry_age_from
#   agree_ben.max_age = agreement.entry_age_to
#   agree_ben.exit_age = agreement.exit_age
#   agree_ben.insured_type = ab[1]
#   puts "#{ab[0]} - Done!" if agree_ben.save!
  
# end

#Product Benefit
# [
#   #Option 1
#   [18, 'Life Insurance', 50000, 155],
#   [18, 'Accidental Death & Dismemberment', 50000, 155],
#   [18, 'Burial Benefit(Natural)', 5000, 25],
#   #Option 2
#   [19, 'Life Insurance', 200000, 615],
#   [19, 'Accidental Death & Dismemberment', 200000, 615],
#   [19, 'Burial Benefit(Natural)', 20000, 100],
#   #Option 3
#   [20, 'Life Insurance', 400000, 1225],
#   [20, 'Accidental Death & Dismemberment', 400000, 1225],
#   [20, 'Burial Benefit(Natural)', 20000, 100],
#   #Option 4
#   [21, 'Life Insurance', 1000000, 3967.5],
#   [21, 'Accidental Death & Dismemberment', 1000000, 3967.5],
#   [21, 'Burial Benefit(Natural)', 20000, 100],
#   #Option 5
#   [22, 'Life Insurance', 2000000, 8422.5],
#   [22, 'Accidental Death & Dismemberment', 2000000, 8422.5],
#   [22, 'Burial Benefit(Natural)', 20000, 100]
# ].each do |option|
#   benefit = Benefit.find_by(name: option[1])
#   prod_ben = ProductBenefit.find_or_initialize_by(agreement_benefit_id: option[0], benefit_id: benefit.id)
#   prod_ben.coverage_amount = option[2]
#   prod_ben.premium = option[3]
#   puts "#{prod_ben.agreement_benefit.name}(#{prod_ben.benefit.name}) - Done" if prod_ben.save!
# end


# JFC Dependents

# agreement = Agreement.find_by(id: 8)

# [
#   ['Dependent-Spouse 1', 2, 18, 65], #23
#   ['Dependent-Spouse 2', 2, 18, 65], #27
#   ['Dependent-Spouse 3', 2, 18, 65], #28
#   ['Dependent-Parent 1', 3, 18, 65], #24
#   ['Dependent-Parent 2', 3, 18, 65], #29
#   ['Dependent-Parent 3', 3, 18, 65], #30
#   ['Dependent-Child 1', 4, 3, 21], #25
#   ['Dependent-Child 2', 4, 3, 21], #31
#   ['Dependent-Child 3', 4, 3, 21], #32
#   ['Dependent-Sibling 1', 5, 3, 21], #26
#   ['Dependent-Sibling 2', 5, 3, 21], #33
#   ['Dependent-Sibling 3', 5, 3, 21], #34
# ].each do |dep|
#   agree_ben = AgreementBenefit.find_or_initialize_by(agreement_id: agreement.id, name: dep[0])
#   agree_ben.proposal_id = agreement.proposal_id
#   agree_ben.min_age = dep[2]
#   agree_ben.max_age = dep[3]
#   agree_ben.exit_age = dep[3]
#   agree_ben.insured_type = dep[1]
#   puts "#{dep[0]} - Done!" if agree_ben.save!
# end

# [
#   #spouse option 1
#   [23, "Life Insurance", 50000, 240],
#   [23, "Accidental Death & Dismemberment", 50000, 240],
#   [23, "Burial Benefit(Natural)", 5000, 25],
#   #spouse option 2
#   [27, "Life Insurance", 200000, 955],
#   [27, "Accidental Death & Dismemberment", 200000, 955],
#   [27, "Burial Benefit(Natural)", 20000, 100],
#   #spouse option 3
#   [28, "Life Insurance", 400000, 1875],
#   [28, "Accidental Death & Dismemberment", 400000, 1875],
#   [28, "Burial Benefit(Natural)", 20000, 100],
#   #parent option 1
#   [24, "Life Insurance", 50000, 240],
#   [24, "Accidental Death & Dismemberment", 50000, 240],
#   [24, "Burial Benefit(Natural)", 5000, 25],
#   #parent option 2
#   [29, "Life Insurance", 200000, 955],
#   [29, "Accidental Death & Dismemberment", 200000, 955],
#   [29, "Burial Benefit(Natural)", 20000, 100],
#   #parent option 3
#   [30, "Life Insurance", 400000, 1875],
#   [30, "Accidental Death & Dismemberment", 400000, 1875],
#   [30, "Burial Benefit(Natural)", 20000, 100],
#   #child option 1
#   [25, "Life Insurance", 50000, 60],
#   [25, "Accidental Death & Dismemberment", 50000, 60],
#   [25, "Burial Benefit(Natural)", 5000, 25],
#   #child option 2
#   [31, "Life Insurance", 200000, 235],
#   [31, "Accidental Death & Dismemberment", 200000, 235],
#   [31, "Burial Benefit(Natural)", 20000, 100],
#   #child option 3
#   [32, "Life Insurance", 400000, 497.5],
#   [32, "Accidental Death & Dismemberment", 400000, 497.5],
#   [32, "Burial Benefit(Natural)", 20000, 100],
#   #sibling option 1
#   [26, "Life Insurance", 50000, 60],
#   [26, "Accidental Death & Dismemberment", 50000, 60],
#   [26, "Burial Benefit(Natural)", 5000, 25],
#   #sibling option 2
#   [33, "Life Insurance", 200000, 235],
#   [33, "Accidental Death & Dismemberment", 200000, 235],
#   [33, "Burial Benefit(Natural)", 20000, 100],
#   #sibling option 3
#   [34, "Life Insurance", 400000, 497.5],
#   [34, "Accidental Death & Dismemberment", 400000, 497.5],
#   [34, "Burial Benefit(Natural)", 20000, 100],
# ].each do |option|
#   benefit = Benefit.find_by(name: option[1])
#   prod_ben = ProductBenefit.find_or_initialize_by(agreement_benefit_id: option[0], benefit_id: benefit.id)
#   prod_ben.coverage_amount = option[2]
#   prod_ben.premium = option[3]
#   puts "#{prod_ben.agreement_benefit.name}(#{prod_ben.benefit.name}) - Done" if prod_ben.save!
# end

####################### PMFC seed data

# PMFC import
coop = Cooperative.find_or_initialize_by(name: "PEOPLE’S MICRO FINANCE COOP")
coop.region = "NCR"
coop.province = 'Metro Manila'
coop.municipality = 'Pasig City'
coop.cooperative_type = 'Multi-Purpose'
coop.street = 'PMFC Plaza, Ortigas Center'
coop.email = 'pmfc@coop.com'
coop.save!

CoopBranch.create!(name: "PMFC Branch 1", cooperative_id: 97, region: "Region 1", province: "Province 1", municipality: "Municipality 1", barangay: "Barangay 1", street: "Street 1", contact_details: "09123456789")

# Coop User
CoopUser.create!(first_name: 'Cherry', last_name: 'Gonzales', middle_name: 'P', birthdate: FFaker::Time.date, mobile_number: '09948423385', coop_branch_id: 11, cooperative_id: 97)
User.create!(email: 'pmfc@gmail.com', password: 'password', password_confirmation: 'password',  approved: true, userable_id: 2, userable_type: 'CoopUser')

# PMFC Proposal
Proposal.create!(proposal_no: 'PMFC-PROP-00001', cooperative_id: 97, coop_sf: 10, agent_sf: 10, ave_age: 50, minimum_participation: 3)

# PMFC Plan
Plan.create!(name: 'Special Term Insurance (PMFC)', description: 'Special term insurance for PEOPLE’S MICRO FINANCE COOP', gyrt_type: 'family', acronym: 'PMFC')

# PMFC Benefits
Benefit.create!(name: 'Life', description: 'Benefit 2 description', abbreviation: 'LI')
Benefit.create!(name: 'Accidental Death & Dismemberment', description: 'Benefit 2 description', abbreviation: 'ADD')
Benefit.create!(name: 'Burial Cash Assistance', description: 'Benefit 2 description', abbreviation: 'BCA')

# PMFC Agreement
Agreement.create!(proposal_id: 2, moa_no: 'PMFC-MOA-00001', description: '', plan_id: 1, agent_id: 1, cooperative_id: 97, anniversary_type: 'none')

# PMFC Agreement Benefit
# for Principal (name, insured_type)
agreement = Agreement.find_by(id: 5)
[
  ['Principal', 1
  ],
  ['Spouse', 2
  ],
  ['Parent', 3
  ],
  ['Children', 4
  ],
  ['Sibling', 5
  ]
].each do |ab|
  agree_ben = AgreementBenefit.find_or_initialize_by(agreement_id: agreement.id, name: ab[0])
  agree_ben.proposal_id = agreement.proposal_id
  case ab[1]
  when 1 || 2 || 3
    agree_ben.min_age = 18
    agree_ben.max_age = 65
    agree_ben.exit_age = 79.5
  when 4
    agree_ben.min_age = 0.038
    agree_ben.max_age = 21
    agree_ben.exit_age = 21.5
  when 5
    agree_ben.min_age = 1
    agree_ben.max_age = 21
    agree_ben.exit_age = 21.5
  end
  agree_ben.insured_type = ab[1]
  puts "#{ab[0]} - Done!" if agree_ben.save!
  
end

[
    #spouse option 1
    [, "Life Insurance", 50000, 240],
    [23, "Accidental Death & Dismemberment", 50000, 240],
    [23, "Burial Benefit(Natural)", 5000, 25],
    #spouse option 2
    [27, "Life Insurance", 200000, 955],
    [27, "Accidental Death & Dismemberment", 200000, 955],
    [27, "Burial Benefit(Natural)", 20000, 100],
    #spouse option 3
    [28, "Life Insurance", 400000, 1875],
    [28, "Accidental Death & Dismemberment", 400000, 1875],
    [28, "Burial Benefit(Natural)", 20000, 100],
    #parent option 1
    [24, "Life Insurance", 50000, 240],
    [24, "Accidental Death & Dismemberment", 50000, 240],
    [24, "Burial Benefit(Natural)", 5000, 25],
    #parent option 2
    [29, "Life Insurance", 200000, 955],
    [29, "Accidental Death & Dismemberment", 200000, 955],
    [29, "Burial Benefit(Natural)", 20000, 100],
    #parent option 3
    [30, "Life Insurance", 400000, 1875],
    [30, "Accidental Death & Dismemberment", 400000, 1875],
    [30, "Burial Benefit(Natural)", 20000, 100],
    #child option 1
    [25, "Life Insurance", 50000, 60],
    [25, "Accidental Death & Dismemberment", 50000, 60],
    [25, "Burial Benefit(Natural)", 5000, 25],
    #child option 2
    [31, "Life Insurance", 200000, 235],
    [31, "Accidental Death & Dismemberment", 200000, 235],
    [31, "Burial Benefit(Natural)", 20000, 100],
    #child option 3
    [32, "Life Insurance", 400000, 497.5],
    [32, "Accidental Death & Dismemberment", 400000, 497.5],
    [32, "Burial Benefit(Natural)", 20000, 100],
    #sibling option 1
    [26, "Life Insurance", 50000, 60],
    [26, "Accidental Death & Dismemberment", 50000, 60],
    [26, "Burial Benefit(Natural)", 5000, 25],
    #sibling option 2
    [33, "Life Insurance", 200000, 235],
    [33, "Accidental Death & Dismemberment", 200000, 235],
    [33, "Burial Benefit(Natural)", 20000, 100],
    #sibling option 3
    [34, "Life Insurance", 400000, 497.5],
    [34, "Accidental Death & Dismemberment", 400000, 497.5],
    [34, "Burial Benefit(Natural)", 20000, 100],
  ].each do |option|
    benefit = Benefit.find_by(name: option[1])
    prod_ben = ProductBenefit.find_or_initialize_by(agreement_benefit_id: option[0], benefit_id: benefit.id)
    prod_ben.coverage_amount = option[2]
    prod_ben.premium = option[3]
    puts "#{prod_ben.agreement_benefit.name}(#{prod_ben.benefit.name}) - Done" if prod_ben.save!
  end