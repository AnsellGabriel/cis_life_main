# # # This file should contain all the record creation needed to seed the database with its default values.
# # # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# # #
# # # Examples:
# # #
# # #   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
# # #   Character.create(name: "Luke", movie: movies.first)
# # # spreadsheet = Roo::Spreadsheet.open("./db/uploads/benefits.xlsx")

# # # (2..spreadsheet.last_row).each do |row|
# # #     benefit = Benefit.find_or_initialize_by(name: spreadsheet.cell(row, 'A'))
# # #     benefit.acronym = spreadsheet.cell(row,'B')
# # #     puts "#{benefit.name}" if benefit.save!
# # # end

# # # # Cooperatives

# # # # Admin
# # # # AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# # # # Cooperative
# # # cooperatives_spreadsheet = Roo::Spreadsheet.open("/Users/macbookair/Desktop/cis_data/Operating-Coops.xlsx")
# # # (5..100).each do |row|
# # #     spreadsheet = cooperatives_spreadsheet
# # #     Cooperative.find_or_create_by!(
# # #         registration_number: spreadsheet.cell(row, 'A'), 
# # #         name: spreadsheet.cell(row, 'B'), 
# # #         region: spreadsheet.cell(row, 'C'), 
# # #         province: spreadsheet.cell(row, 'D'), 
# # #         municipality: spreadsheet.cell(row, 'E'), 
# # #         street: spreadsheet.cell(row, 'F'), 
# # #         cooperative_type: spreadsheet.cell(row, 'H'),
# # #         email: spreadsheet.cell(row, 'K'), 
# # #         contact_number: spreadsheet.cell(row, 'J'),
# # #     )
# # # end

# # # # Plan
# # # Plan.create!(name: 'GYRT-Basic', description: 'Plan 1 description', gyrt_type: 'basic', acronym: 'GYRT')
# # # Plan.create!(name: 'GYRT-Family', description: 'Plan 2 description', gyrt_type: 'family', acronym: 'GYRTF')
# # # Plan.create!(name: 'GYRT-Basic Ranking', description: 'Plan 3 description', gyrt_type: 'basic', acronym: 'GYRTBR')
# Plan.create!(name: 'GYRT-Family Ranking', description: 'Plan 4 description', gyrt_type: 'family', acronym: 'GYRTFR')






# # # # GYRT Basic Single Anniversary  
# # # Agreement.create!(proposal_id: 1, moa_no: 'GYRT Basic - Single Anniversary', description: 'Agreement with a single anniversary type', plan_id: 1, agent_id: 1, cooperative_id: 1, anniversary_type: 'single')
# # # AgreementBenefit.create!(agreement_id: 1, proposal_id: 1, name: 'Agreement Benefit principal', min_age: 18, max_age: 65, insured_type: 1)
# # # ProductBenefit.create!(coverage_amount: 150000,benefit_id: 1, agreement_benefit_id: 1, premium: 200)
# # # ProductBenefit.create!(coverage_amount: 100000,benefit_id: 2, agreement_benefit_id: 1, premium: 150)
# # # Anniversary.create!(agreement_id: 1, name: 'May 31', anniversary_date: '2023/05/31')

# # # # GYRT Family Multiple Anniversary
# # # Agreement.create!(proposal_id: 1, moa_no: 'GYRT Family - No Anniversary date', description: 'Agreement with a mutiple anniversary type', plan_id: 2, agent_id: 1, cooperative_id: 1, anniversary_type: 'none')
# # # ### Principal
# # # AgreementBenefit.create!(agreement_id: 2, proposal_id: 1, name: 'Agreement Benefit principal', min_age: 18, max_age: 65, insured_type: 1)
# # # ProductBenefit.create!(coverage_amount: 150000,benefit_id: 1, agreement_benefit_id: 2, premium: 200)
# # # ### Dependent - Spouse
# # # AgreementBenefit.create!(agreement_id: 2, proposal_id: 1, name: 'Agreement Benefit dependent', min_age: 18, max_age: 65, insured_type: 2)
# # # ProductBenefit.create!(coverage_amount: 75000,benefit_id: 1, agreement_benefit_id: 3, premium: 100)
# # # ### Dependent - Parent
# # # AgreementBenefit.create!(agreement_id: 2, proposal_id: 1, name: 'Agreement Benefit principal', min_age: 18, max_age: 65, insured_type: 3)
# # # ProductBenefit.create!(coverage_amount: 100000,benefit_id: 1, agreement_benefit_id: 4, premium: 150)
# # # ### Dependent - Child
# # # AgreementBenefit.create!(agreement_id: 2, proposal_id: 1, name: 'Agreement Benefit principal', min_age: 18, max_age: 65, insured_type: 4)
# # # ProductBenefit.create!(coverage_amount: 50000,benefit_id: 1, agreement_benefit_id: 5, premium: 50)
# # # ### Dependent - Sibling
# # # AgreementBenefit.create!(agreement_id: 2, proposal_id: 1, name: 'Agreement Benefit principal', min_age: 18, max_age: 65, insured_type: 5)
# # # ProductBenefit.create!(coverage_amount: 75000,benefit_id: 1, agreement_benefit_id: 6, premium: 100)

# # # # # GYRT Basic No Anniversary
# # # # Agreement.create!(proposal_id: 1, moa_no: 'GYRT-MOA-0002', description: 'Agreement with no anniversary type', plan_id: 1, agent_id: 1, cooperative_id: 1, anniversary_type: 'none')
# # # # AgreementBenefit.create!(agreement_id: 3, proposal_id: 1, name: 'Agreement Benefit principal', min_age: 18, max_age: 65, insured_type: 1)
# # # # ProductBenefit.create!(coverage_amount: 150000,benefit_id: 1, agreement_benefit_id: 7, premium: 200)
# # # # ProductBenefit.create!(coverage_amount: 100000,benefit_id: 2, agreement_benefit_id: 7, premium: 150)

# # # # GYRT Ranking - Basic
# # # Agreement.create!(proposal_id: 1, moa_no: 'GYRT Ranking - Multiple Anniversary', description: 'Agreement with ranking type', plan_id: 3, agent_id: 1, cooperative_id: 1, anniversary_type: 'multiple')

# # # AgreementBenefit.create!(agreement_id: 3, proposal_id: 1, name: 'Agreement Benefit BOD', min_age: 18, max_age: 65, insured_type: 6)
# # # AgreementBenefit.create!(agreement_id: 3, proposal_id: 1, name: 'Agreement Benefit SO', min_age: 18, max_age: 65, insured_type: 7)
# # # AgreementBenefit.create!(agreement_id: 3, proposal_id: 1, name: 'Agreement Benefit JO', min_age: 18, max_age: 65, insured_type: 8)
# # # AgreementBenefit.create!(agreement_id: 3, proposal_id: 1, name: 'Agreement Benefit Rank & File', min_age: 18, max_age: 65, insured_type: 9)

# # #   dept = Department.find_or_initialize_by(name: spreadsheet.cell(emp, "F"))
# # #   dept.description = ""
# # #   puts "#{dept.name} - saved" if dept.save!

# # #   employee = Employee.find_or_initialize_by(
# # #     last_name: spreadsheet.cell(emp, "B"),
# # #     first_name: spreadsheet.cell(emp, "C"),
# # #     middle_name: spreadsheet.cell(emp, "D")
# # #   )
# # #   employee.department_id = dept.id
# # #   employee.birthdate = ""
# # #   employee.designation = spreadsheet.cell(emp, "G")
# # #   employee.employee_number = spreadsheet.cell(emp, "A")
# # #   employee.mobile_number = ""
# # #   puts "#{employee.last_name} - DONE!" if employee.save!
  
# # #   user = User.find_or_initialize_by(email: email)
# # #   user.password = user_name
# # #   user.userable = employee
# # #   user.admin = spreadsheet.cell(emp, "H")
# # #   user.approved = true
# # #   puts "#{user.email} - DONE!" if user.save!
# # # end
# # # =======
# # # # CoopBranch of Coop 1
# # # 10.times do |i|
# # #     CoopBranch.create!(name: "Branch #{i+1}", cooperative_id: 1, region: "Region 1", province: "Province 1", municipality: "Municipality 1", barangay: "Barangay 1", street: "Street 1", contact_details: "09123456789")
# # # end


# # # HealthDec.create!(question: "Do you drink alcohol?", active: true, with_details: true, valid_answer: false)
# # # HealthDecSubquestion.create!(question: "Please state whether beer, wine, or spirits; and your average daily consumption", health_dec_id: 6)


# # ######################## PMFC seed data

# # # # PMFC import
# coop = Cooperative.find_or_initialize_by(name: "PEOPLE’S MICRO FINANCE COOP")
# coop.region = "NCR"
# coop.province = 'Metro Manila'
# coop.municipality = 'Pasig City'
# coop.cooperative_type = 'Multi-Purpose'
# coop.street = 'PMFC Plaza, Ortigas Center'
# coop.email = 'pmfc@coop.com'
# coop.save!

# CoopBranch.create!(name: "PMFC Branch 1", cooperative_id: 1, region: "Region 1", province: "Province 1", municipality: "Municipality 1", barangay: "Barangay 1", street: "Street 1", contact_details: "09123456789")

# # # # # Coop User
# CoopUser.create!(first_name: 'Cherry', last_name: 'Gonzales', middle_name: 'P', birthdate: FFaker::Time.date, mobile_number: '09948423385', coop_branch_id: 1, cooperative_id: 1)
# User.create!(email: 'pmfc@gmail.com', password: 'password', password_confirmation: 'password',  approved: true, userable_id: 1, userable_type: 'CoopUser')


# # AgentGroup
# AgentGroup.create!(name: 'Marketing', description: 'Marketing Group')

# # # Agent
# Agent.create!(first_name: 'Rullian', middle_name: 'Postrano', last_name: 'Rong', agent_group_id: 1)

# # # # # PMFC Plan
# Plan.create!(name: 'Special Term Insurance (PMFC)', description: 'Special term insurance for PEOPLE’S MICRO FINANCE COOP', gyrt_type: 'family', acronym: 'PMFC')

# # # # # PMFC Benefits
# Benefit.create!(name: 'Life', description: 'Benefit 2 description', acronym: 'LI')
# Benefit.create!(name: 'Accidental Death & Dismemberment', description: 'Benefit 2 description', acronym: 'ADD')
# Benefit.create!(name: 'Burial Cash Assistance', description: 'Benefit 2 description', acronym: 'BCA')

# # # # # # PMFC Agreement
# Agreement.create!(moa_no: 'PMFC-MOA-00001', description: '', plan_id: 1, agent_id: 1, cooperative_id: 1, anniversary_type: 'none', coop_sf: 12.5, agent_sf: 10, minimum_participation: 100)

# # # # PMFC Agreement Benefit
# # # # for Principal (name, insured_type)
# pmfc_agreement = Agreement.find_by(id: 1) # Use agreement.id instead of hardcoded 1
# benefits = [
#   ['Principal', 1],
#   ['Spouse', 2],
#   ['Parent', 3],
#   ['Children', 4],
#   ['Sibling', 5]
# ]

# benefits.each do |benefit|
#   agree_ben = AgreementBenefit.find_or_initialize_by(agreement_id: pmfc_agreement.id, name: benefit[0])

#   case benefit[1]
#   when 1, 2, 3
#     agree_ben.min_age = 18
#     agree_ben.max_age = 65
#     agree_ben.exit_age = 79.5
#   when 4
#     agree_ben.min_age = 0.038
#     agree_ben.max_age = 21
#     agree_ben.exit_age = 21.5
#   when 5
#     agree_ben.min_age = 1
#     agree_ben.max_age = 21
#     agree_ben.exit_age = 21.5
#   end

#   agree_ben.insured_type = benefit[1]

#   if agree_ben.save
#     puts "#{benefit[0]} - Done!"
#   else
#     puts "Failed to save #{benefit[0]}"
#   end
# end


# # # # PMFC Product Benefit
# insured_type = [1, 2, 3, 4, 5]
# duration = [3, 4, 5, 6, 9, 12]
# residency = {
#   "0-6 months" => 1,
#   "7-12 months" => 2,
#   "13-54 months" => 3,
#   "55-89 months" => 4,
#   "90-119 months" => 5,
#   "120 months & above" => 6
# }
# benefits = [1 , 2, 3]

# duration.each do |dur|
#   puts "Duration: #{dur}"
#   insured_type.each do |ins|
#     puts "Insured_type: #{ins}"
#     residency.each do |res|
#       puts "Residency: #{res[0]}"
#       benefits.each do |ben|
#         puts "Benefit: #{ben}"

#         prod_ben = ProductBenefit.create!(
#           agreement_benefit_id: AgreementBenefit.find_by(insured_type: ins).id,
#           benefit_id: ben
#         )

#         case ins
#         when 1
#           if res[1] == 1
#             case ben
#             when 1
#               prod_ben.coverage_amount = 10000
#             when 2
#               prod_ben.coverage_amount = 40000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 2
#             case ben
#             when 1
#               prod_ben.coverage_amount = 30000
#             when 2
#               prod_ben.coverage_amount = 40000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 3
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 50000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 4
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 75000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 5
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 85000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 6
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 95000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           end

#           case res[1]
#           when 1,2,3,4
#             case dur
#             when 3
#               prod_ben.premium = 200
#             when 4
#               prod_ben.premium = 260
#             when 5
#               prod_ben.premium = 320
#             when 6
#               prod_ben.premium = 380
#             when 9
#               prod_ben.premium = 580
#             when 12
#               prod_ben.premium = 760
#             end
#           when 5
#             case dur
#             when 3
#               prod_ben.premium = 290
#             when 4
#               prod_ben.premium = 390
#             when 5
#               prod_ben.premium = 465
#             when 6
#               prod_ben.premium = 580
#             when 9
#               prod_ben.premium = 870
#             when 12
#               prod_ben.premium = 1160
#             end
#           when 6
#             case dur
#             when 3
#               prod_ben.premium = 390
#             when 4
#               prod_ben.premium = 520
#             when 5
#               prod_ben.premium = 625
#             when 6
#               prod_ben.premium = 780
#             when 9
#               prod_ben.premium = 1170
#             when 12
#               prod_ben.premium = 1560
#             end
#           end


#         when 2, 3
#           if res[1] == 1
#             case ben
#             when 1
#               prod_ben.coverage_amount = 7500
#             when 2
#               prod_ben.coverage_amount = 20000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 2
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 20000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 3
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 25000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 4
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 40000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 5
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 50000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 6
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 60000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           end

#           if ins == 2
#             case res[1]
#             when 1,2,3,4
#               case dur
#               when 3
#                 prod_ben.premium = 180
#               when 4
#                 prod_ben.premium = 250
#               when 5
#                 prod_ben.premium = 300
#               when 6
#                 prod_ben.premium = 350
#               when 9
#                 prod_ben.premium = 560
#               when 12
#                 prod_ben.premium = 720
#               end
#             when 5
#               case dur
#               when 3
#                 prod_ben.premium = 270
#               when 4
#                 prod_ben.premium = 360
#               when 5
#                 prod_ben.premium = 430
#               when 6
#                 prod_ben.premium = 535
#               when 9
#                 prod_ben.premium = 805
#               when 12
#                 prod_ben.premium = 1070
#               end
#             when 6
#               case dur
#               when 3
#                 prod_ben.premium = 370
#               when 4
#                 prod_ben.premium = 490
#               when 5
#                 prod_ben.premium = 590
#               when 6
#                 prod_ben.premium = 735
#               when 9
#                 prod_ben.premium = 1105
#               when 12
#                 prod_ben.premium = 1470
#               end
#             end
#           elsif ins == 3
#             case res[1]
#             when 1,2,3,4
#               case dur
#               when 3
#                 prod_ben.premium = 320
#               when 4
#                 prod_ben.premium = 430
#               when 5
#                 prod_ben.premium = 520
#               when 6
#                 prod_ben.premium = 650
#               when 9
#                 prod_ben.premium = 950
#               when 12
#                 prod_ben.premium = 1250
#               end
#             when 5
#               case dur
#               when 3
#                 prod_ben.premium = 425
#               when 4
#                 prod_ben.premium = 570
#               when 5
#                 prod_ben.premium = 680
#               when 6
#                 prod_ben.premium = 850
#               when 9
#                 prod_ben.premium = 1275
#               when 12
#                 prod_ben.premium = 1700
#               end
#             when 6
#               case dur
#               when 3
#                 prod_ben.premium = 475
#               when 4
#                 prod_ben.premium = 635
#               when 5
#                 prod_ben.premium = 760
#               when 6
#                 prod_ben.premium = 950
#               when 9
#                 prod_ben.premium = 1425
#               when 12
#                 prod_ben.premium = 1900
#               end
#             end
#           end
        
#         when 4
#           if res[1] == 1
#             case ben
#             when 1
#               prod_ben.coverage_amount = 5000
#             when 2
#               prod_ben.coverage_amount = 15000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 2
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 15000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 3
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 20000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 4
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 25000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 5
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 30000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 6
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 35000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           end

#           case res[1]
#           when 1,2,3,4
#             case dur
#             when 3
#               prod_ben.premium = 30
#             when 4
#               prod_ben.premium = 40
#             when 5
#               prod_ben.premium = 50
#             when 6
#               prod_ben.premium = 60
#             when 9
#               prod_ben.premium = 85
#             when 12
#               prod_ben.premium = 115
#             end
#           when 5
#             case dur
#             when 3
#               prod_ben.premium = 65
#             when 4
#               prod_ben.premium = 90
#             when 5
#               prod_ben.premium = 105
#             when 6
#               prod_ben.premium = 130
#             when 9
#               prod_ben.premium = 195
#             when 12
#               prod_ben.premium = 260
#             end
#           when 6
#             case dur
#             when 3
#               prod_ben.premium = 165
#             when 4
#               prod_ben.premium = 220
#             when 5
#               prod_ben.premium = 265
#             when 6
#               prod_ben.premium = 330
#             when 9
#               prod_ben.premium = 495
#             when 12
#               prod_ben.premium = 660
#             end
#           end
#         when 5
#           if res[1] == 1
#             case ben
#             when 1
#               prod_ben.coverage_amount = 5000
#             when 2
#               prod_ben.coverage_amount = 10000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 2
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 10000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 3
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 15000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 4
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 20000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 5
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 25000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 6
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 30000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           end

#           case res[1]
#           when 1,2,3,4
#             case dur
#             when 3
#               prod_ben.premium = 20
#             when 4
#               prod_ben.premium = 30
#             when 5
#               prod_ben.premium = 40
#             when 6
#               prod_ben.premium = 50
#             when 9
#               prod_ben.premium = 80
#             when 12
#               prod_ben.premium = 90
#             end
#           when 5
#             case dur
#             when 3
#               prod_ben.premium = 50
#             when 4
#               prod_ben.premium = 70
#             when 5
#               prod_ben.premium = 80
#             when 6
#               prod_ben.premium = 100
#             when 9
#               prod_ben.premium = 150
#             when 12
#               prod_ben.premium = 200
#             end
#           when 6
#             case dur
#             when 3
#               prod_ben.premium = 150
#             when 4
#               prod_ben.premium = 200
#             when 5
#               prod_ben.premium = 240
#             when 6
#               prod_ben.premium = 300
#             when 9
#               prod_ben.premium = 450
#             when 12
#               prod_ben.premium = 600
#             end
#           end
          
#         end

#         case res[1]
#         when 1
#           prod_ben.residency_floor = 0
#           prod_ben.residency_ceiling = 6
#         when 2
#           prod_ben.residency_floor = 7
#           prod_ben.residency_ceiling = 12
#         when 3
#           prod_ben.residency_floor = 13
#           prod_ben.residency_ceiling = 54
#         when 4
#           prod_ben.residency_floor = 55
#           prod_ben.residency_ceiling = 89
#         when 5
#           prod_ben.residency_floor = 90
#           prod_ben.residency_ceiling = 119
#         when 6
#           prod_ben.residency_floor = 120
#           prod_ben.residency_ceiling = nil
#         end

#         prod_ben.benefit_type = 'special'
#         prod_ben.duration = dur
#         prod_ben.save!
#       end
#     end
#   end
# end


# # # # JFC COOP Import
# coop = Cooperative.find_or_initialize_by(name: "Jollibee Foods Corporation Employees Multi-Purpose Cooperative")
# coop.region = "NCR"
# coop.province = 'Metro Manila'
# coop.municipality = 'Pasig City'
# coop.cooperative_type = 'Multi-Purpose'
# coop.street = 'Jollibee Plaza, Ortigas Center'
# coop.email = 'JFC@coop.com'
# coop.save!

# CoopBranch.create!(name: "JFC Branch 1", cooperative_id: 2, region: "Region 1", province: "Province 1", municipality: "Municipality 1", barangay: "Barangay 1", street: "Street 1", contact_details: "09123456789")


# # # # # Coop User
# CoopUser.create!(first_name: 'Cherry', last_name: 'Gonzales', middle_name: 'P', birthdate: FFaker::Time.date, mobile_number: '09948423385', coop_branch_id: 2, cooperative_id: 2)
# User.create!(email: 'jfc@gmail.com', password: 'password', password_confirmation: 'password',  approved: true, userable_id: 2, userable_type: 'CoopUser')

# Plan.create!(name: 'GYRT-Family Ranking', description: 'Plan 4 description', gyrt_type: 'family', acronym: 'GYRTFR')

# # # # #Agreement
# agreement = Agreement.create!(plan_id: 2, cooperative_id: 2, agent_id: 1, moa_no: "JFC-0001", contestability: 12, nel: 25000, nml: 5000000, anniversary_type: 'multiple', transferred: 0, comm_type: "Gross Commission", entry_age_from: 18, entry_age_to: 65, exit_age: 80, coop_sf: 12.5, agent_sf: 10, minimum_participation: 100)
# # # # # GYRT Family Multiple Anniversary
# Anniversary.create!(agreement_id: 2, anniversary_date: '2023/12/25')
# Anniversary.create!(agreement_id: 2, anniversary_date: '2023/10/25')
# Anniversary.create!(agreement_id: 2, anniversary_date: '2023/11/25')


# # # # for Principal (name, insured_type)
# pmfc_agreement = Agreement.find_by(id: 1) # Use agreement.id instead of hardcoded 1
# benefits = [
#   ['Principal', 1],
#   ['Spouse', 2],
#   ['Parent', 3],
#   ['Children', 4],
#   ['Sibling', 5]
# ]

# benefits.each do |benefit|
#   agree_ben = AgreementBenefit.find_or_initialize_by(agreement_id: pmfc_agreement.id, name: benefit[0])

#   case benefit[1]
#   when 1, 2, 3
#     agree_ben.min_age = 18
#     agree_ben.max_age = 65
#     agree_ben.exit_age = 79.5
#   when 4
#     agree_ben.min_age = 0.038
#     agree_ben.max_age = 21
#     agree_ben.exit_age = 21.5
#   when 5
#     agree_ben.min_age = 1
#     agree_ben.max_age = 21
#     agree_ben.exit_age = 21.5
#   end

#   agree_ben.insured_type = benefit[1]

#   if agree_ben.save
#     puts "#{benefit[0]} - Done!"
#   else
#     puts "Failed to save #{benefit[0]}"
#   end
# end


# # # # PMFC Product Benefit
# insured_type = [1, 2, 3, 4, 5]
# duration = [3, 4, 5, 6, 9, 12]
# residency = {
#   "0-6 months" => 1,
#   "7-12 months" => 2,
#   "13-54 months" => 3,
#   "55-89 months" => 4,
#   "90-119 months" => 5,
#   "120 months & above" => 6
# }
# benefits = [1 , 2, 3]

# duration.each do |dur|
#   puts "Duration: #{dur}"
#   insured_type.each do |ins|
#     puts "Insured_type: #{ins}"
#     residency.each do |res|
#       puts "Residency: #{res[0]}"
#       benefits.each do |ben|
#         puts "Benefit: #{ben}"

#         prod_ben = ProductBenefit.create!(
#           agreement_benefit_id: AgreementBenefit.find_by(insured_type: ins).id,
#           benefit_id: ben
#         )

#         case ins
#         when 1
#           if res[1] == 1
#             case ben
#             when 1
#               prod_ben.coverage_amount = 10000
#             when 2
#               prod_ben.coverage_amount = 40000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 2
#             case ben
#             when 1
#               prod_ben.coverage_amount = 30000
#             when 2
#               prod_ben.coverage_amount = 40000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 3
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 50000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 4
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 75000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 5
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 85000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 6
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 95000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           end

#           case res[1]
#           when 1,2,3,4
#             case dur
#             when 3
#               prod_ben.premium = 200
#             when 4
#               prod_ben.premium = 260
#             when 5
#               prod_ben.premium = 320
#             when 6
#               prod_ben.premium = 380
#             when 9
#               prod_ben.premium = 580
#             when 12
#               prod_ben.premium = 760
#             end
#           when 5
#             case dur
#             when 3
#               prod_ben.premium = 290
#             when 4
#               prod_ben.premium = 390
#             when 5
#               prod_ben.premium = 465
#             when 6
#               prod_ben.premium = 580
#             when 9
#               prod_ben.premium = 870
#             when 12
#               prod_ben.premium = 1160
#             end
#           when 6
#             case dur
#             when 3
#               prod_ben.premium = 390
#             when 4
#               prod_ben.premium = 520
#             when 5
#               prod_ben.premium = 625
#             when 6
#               prod_ben.premium = 780
#             when 9
#               prod_ben.premium = 1170
#             when 12
#               prod_ben.premium = 1560
#             end
#           end


#         when 2, 3
#           if res[1] == 1
#             case ben
#             when 1
#               prod_ben.coverage_amount = 7500
#             when 2
#               prod_ben.coverage_amount = 20000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 2
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 20000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 3
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 25000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 4
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 40000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 5
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 50000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 6
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 60000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           end

#           if ins == 2
#             case res[1]
#             when 1,2,3,4
#               case dur
#               when 3
#                 prod_ben.premium = 180
#               when 4
#                 prod_ben.premium = 250
#               when 5
#                 prod_ben.premium = 300
#               when 6
#                 prod_ben.premium = 350
#               when 9
#                 prod_ben.premium = 560
#               when 12
#                 prod_ben.premium = 720
#               end
#             when 5
#               case dur
#               when 3
#                 prod_ben.premium = 270
#               when 4
#                 prod_ben.premium = 360
#               when 5
#                 prod_ben.premium = 430
#               when 6
#                 prod_ben.premium = 535
#               when 9
#                 prod_ben.premium = 805
#               when 12
#                 prod_ben.premium = 1070
#               end
#             when 6
#               case dur
#               when 3
#                 prod_ben.premium = 370
#               when 4
#                 prod_ben.premium = 490
#               when 5
#                 prod_ben.premium = 590
#               when 6
#                 prod_ben.premium = 735
#               when 9
#                 prod_ben.premium = 1105
#               when 12
#                 prod_ben.premium = 1470
#               end
#             end
#           elsif ins == 3
#             case res[1]
#             when 1,2,3,4
#               case dur
#               when 3
#                 prod_ben.premium = 320
#               when 4
#                 prod_ben.premium = 430
#               when 5
#                 prod_ben.premium = 520
#               when 6
#                 prod_ben.premium = 650
#               when 9
#                 prod_ben.premium = 950
#               when 12
#                 prod_ben.premium = 1250
#               end
#             when 5
#               case dur
#               when 3
#                 prod_ben.premium = 425
#               when 4
#                 prod_ben.premium = 570
#               when 5
#                 prod_ben.premium = 680
#               when 6
#                 prod_ben.premium = 850
#               when 9
#                 prod_ben.premium = 1275
#               when 12
#                 prod_ben.premium = 1700
#               end
#             when 6
#               case dur
#               when 3
#                 prod_ben.premium = 475
#               when 4
#                 prod_ben.premium = 635
#               when 5
#                 prod_ben.premium = 760
#               when 6
#                 prod_ben.premium = 950
#               when 9
#                 prod_ben.premium = 1425
#               when 12
#                 prod_ben.premium = 1900
#               end
#             end
#           end
        
#         when 4
#           if res[1] == 1
#             case ben
#             when 1
#               prod_ben.coverage_amount = 5000
#             when 2
#               prod_ben.coverage_amount = 15000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 2
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 15000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 3
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 20000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 4
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 25000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 5
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 30000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 6
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 35000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           end

#           case res[1]
#           when 1,2,3,4
#             case dur
#             when 3
#               prod_ben.premium = 30
#             when 4
#               prod_ben.premium = 40
#             when 5
#               prod_ben.premium = 50
#             when 6
#               prod_ben.premium = 60
#             when 9
#               prod_ben.premium = 85
#             when 12
#               prod_ben.premium = 115
#             end
#           when 5
#             case dur
#             when 3
#               prod_ben.premium = 65
#             when 4
#               prod_ben.premium = 90
#             when 5
#               prod_ben.premium = 105
#             when 6
#               prod_ben.premium = 130
#             when 9
#               prod_ben.premium = 195
#             when 12
#               prod_ben.premium = 260
#             end
#           when 6
#             case dur
#             when 3
#               prod_ben.premium = 165
#             when 4
#               prod_ben.premium = 220
#             when 5
#               prod_ben.premium = 265
#             when 6
#               prod_ben.premium = 330
#             when 9
#               prod_ben.premium = 495
#             when 12
#               prod_ben.premium = 660
#             end
#           end
#         when 5
#           if res[1] == 1
#             case ben
#             when 1
#               prod_ben.coverage_amount = 5000
#             when 2
#               prod_ben.coverage_amount = 10000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 2
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 10000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 3
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 15000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 4
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 20000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 5
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 25000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           elsif res[1] == 6
#             case ben
#             when 1, 2
#               prod_ben.coverage_amount = 30000
#             when 3
#               prod_ben.coverage_amount = 3000
#             end
#           end

#           case res[1]
#           when 1,2,3,4
#             case dur
#             when 3
#               prod_ben.premium = 20
#             when 4
#               prod_ben.premium = 30
#             when 5
#               prod_ben.premium = 40
#             when 6
#               prod_ben.premium = 50
#             when 9
#               prod_ben.premium = 80
#             when 12
#               prod_ben.premium = 90
#             end
#           when 5
#             case dur
#             when 3
#               prod_ben.premium = 50
#             when 4
#               prod_ben.premium = 70
#             when 5
#               prod_ben.premium = 80
#             when 6
#               prod_ben.premium = 100
#             when 9
#               prod_ben.premium = 150
#             when 12
#               prod_ben.premium = 200
#             end
#           when 6
#             case dur
#             when 3
#               prod_ben.premium = 150
#             when 4
#               prod_ben.premium = 200
#             when 5
#               prod_ben.premium = 240
#             when 6
#               prod_ben.premium = 300
#             when 9
#               prod_ben.premium = 450
#             when 12
#               prod_ben.premium = 600
#             end
#           end
          
#         end

#         case res[1]
#         when 1
#           prod_ben.residency_floor = 0
#           prod_ben.residency_ceiling = 6
#         when 2
#           prod_ben.residency_floor = 7
#           prod_ben.residency_ceiling = 12
#         when 3
#           prod_ben.residency_floor = 13
#           prod_ben.residency_ceiling = 54
#         when 4
#           prod_ben.residency_floor = 55
#           prod_ben.residency_ceiling = 89
#         when 5
#           prod_ben.residency_floor = 90
#           prod_ben.residency_ceiling = 119
#         when 6
#           prod_ben.residency_floor = 120
#           prod_ben.residency_ceiling = nil
#         end

#         prod_ben.benefit_type = 'special'
#         prod_ben.duration = dur
#         prod_ben.save!
#       end
#     end
#   end
# end
# AgentGroup
AgentGroup.create!(name: 'Marketing', description: 'Marketing Group')
# # Agent
Agent.create!(first_name: 'Rullian', middle_name: 'Postrano', last_name: 'Rong', agent_group_id: 1)
# Benefit
Benefit.create!(name: 'Life', description: 'Benefit 1 description', acronym: 'LIFE')
Benefit.create!(name: 'Accidental Death & Dismemberment', description: 'Benefit 2 description', acronym: 'ADD')
Benefit.create!(name: 'Burial Cash Assistance', description: 'Benefit 2 description', acronym: 'BCA')

# # # JFC COOP Import
coop = Cooperative.find_or_initialize_by(name: "Jollibee Foods Corporation Employees Multi-Purpose Cooperative")
coop.region = "NCR"
coop.province = 'Metro Manila'
coop.municipality = 'Pasig City'
coop.cooperative_type = 'Multi-Purpose'
coop.street = 'Jollibee Plaza, Ortigas Center'
coop.email = 'JFC@coop.com'
coop.save!

CoopBranch.create!(name: "JFC Branch 1", cooperative_id: 1, region: "Region 1", province: "Province 1", municipality: "Municipality 1", barangay: "Barangay 1", street: "Street 1", contact_details: "09123456789")


# # # # Coop User
CoopUser.create!(first_name: 'Cherry', last_name: 'Gonzales', middle_name: 'P', birthdate: FFaker::Time.date, mobile_number: '09948423385', coop_branch_id: 1, cooperative_id: 1)
User.create!(email: 'jfc@gmail.com', password: 'password', password_confirmation: 'password',  approved: true, userable_id: 1, userable_type: 'CoopUser')

Plan.create!(name: 'GYRT-Family Ranking', description: 'Plan 4 description', gyrt_type: 'family', acronym: 'GYRTFR')

# # # #Agreement
agreement = Agreement.create!(plan_id: 1, cooperative_id: 1, agent_id: 1, moa_no: "JFC-0001", contestability: 12, nel: 25_000, nml: 5_000_000, anniversary_type: 'none', transferred: 0, comm_type: "Gross Commission", entry_age_from: 18, entry_age_to: 65, exit_age: 80, coop_sf: 10, agent_sf: 5, minimum_participation: 100)

# # # # for Principal (name, insured_type)
jfc_agreement = Agreement.find_by(id: 1)
[
  ['Option 1', 9
  ],
  ['Option 2', 9
  ],
  ['Option 3', 8
  ],
  ['Option 4', 7
  ],
  ['Option 5', 6
  ]
].each do |ab|
  agree_ben = AgreementBenefit.find_or_initialize_by(agreement_id: jfc_agreement.id, name: ab[0])
  agree_ben.min_age = jfc_agreement.entry_age_from
  agree_ben.max_age = jfc_agreement.entry_age_to
  agree_ben.exit_age = jfc_agreement.exit_age
  agree_ben.insured_type = ab[1]
  puts "#{ab[0]} - Done!" if agree_ben.save!
  
end

# # #Product Benefit
[
#   Option 1
  [1, 'LIFE', 50000, 155],
  [1, 'ADD', 50000, 155],
  [1, 'BCA', 5000, 25],
  #Option 2
  [2, 'LIFE', 200000, 615],
  [2, 'ADD', 200000, 615],
  [2, 'BCA', 20000, 100],
  #Option 3
  [3, 'LIFE', 400000, 1225],
  [3, 'ADD', 400000, 1225],
  [3, 'BCA', 20000, 100],
  #Option 4
  [4, 'LIFE', 1000000, 3467.5],
  [4, 'ADD', 1000000, 3467.5],
  [4, 'BCA', 20000, 100],
  #Option 5
  [5, 'LIFE', 2000000, 8422.5],
  [5, 'ADD', 2000000, 8422.5],
  [5, 'BCA', 20000, 100]
].each do |option|
  benefit = Benefit.find_by(acronym: option[1])
  prod_ben = ProductBenefit.find_or_initialize_by(agreement_benefit_id: option[0], benefit_id: benefit.id)
  prod_ben.coverage_amount = option[2]
  prod_ben.premium = option[3]
  puts "#{prod_ben.agreement_benefit.name}(#{prod_ben.benefit.name}) - Done" if prod_ben.save!
end


# # # JFC Dependents

agreement = Agreement.find_by(id: 1)

[
  ['Dependent-Spouse 1', 2, 18, 65], #23
  ['Dependent-Spouse 2', 2, 18, 65], #27
  ['Dependent-Spouse 3', 2, 18, 65], #28
  ['Dependent-Parent 1', 3, 18, 65], #24
  ['Dependent-Parent 2', 3, 18, 65], #29
  ['Dependent-Parent 3', 3, 18, 65], #30
  ['Dependent-Child 1', 4, 3, 21], #25
  ['Dependent-Child 2', 4, 3, 21], #31
  ['Dependent-Child 3', 4, 3, 21], #32
  ['Dependent-Sibling 1', 5, 3, 21], #26
  ['Dependent-Sibling 2', 5, 3, 21], #33
  ['Dependent-Sibling 3', 5, 3, 21] #34
].each do |dep|
  agree_ben = AgreementBenefit.find_or_initialize_by(agreement_id: agreement.id, name: dep[0])
  agree_ben.min_age = dep[2]
  agree_ben.max_age = dep[3]
  agree_ben.exit_age = dep[3]
  agree_ben.insured_type = dep[1]
  puts "#{dep[0]} - Done!" if agree_ben.save!
end

[
  #spouse option 1
  [6, "LIFE", 50000, 240],
  [6, "ADD", 50000, 240],
  [6, "BCA", 5000, 25],
  #spouse option 2
  [7, "LIFE", 200000, 955],
  [7, "ADD", 200000, 955],
  [7, "BCA", 20000, 100],
  #spouse option 3
  [8, "LIFE", 400000, 1875],
  [8, "ADD", 400000, 1875],
  [8, "BCA", 20000, 100],
  #parent option 1
  [9, "LIFE", 50000, 240],
  [9, "ADD", 50000, 240],
  [9, "BCA", 5000, 25],
  #parent option 2
  [10, "LIFE", 200000, 955],
  [10, "ADD", 200000, 955],
  [10, "BCA", 20000, 100],
  #parent option 3
  [11, "LIFE", 400000, 1875],
  [11, "ADD", 400000, 1875],
  [11, "BCA", 20000, 100],
  #child option 1
  [12, "LIFE", 50000, 60],
  [12, "ADD", 50000, 60],
  [12, "BCA", 5000, 25],
  #child option 2
  [13, "LIFE", 200000, 235],
  [13, "ADD", 200000, 235],
  [13, "BCA", 20000, 100],
  #child option 3
  [14, "LIFE", 400000, 497.5],
  [14, "ADD", 400000, 497.5],
  [14, "BCA", 20000, 100],
  #sibling option 1
  [15, "LIFE", 50000, 60],
  [15, "ADD", 50000, 60],
  [15, "BCA", 5000, 25],
  #sibling option 2
  [16, "LIFE", 200000, 235],
  [16, "ADD", 200000, 235],
  [16, "BCA", 20000, 100],
  #sibling option 3
  [17, "LIFE", 400000, 497.5],
  [17, "ADD", 400000, 497.5],
  [17, "BCA", 20000, 100],
].each do |option|
  benefit = Benefit.find_by(acronym: option[1])
  prod_ben = ProductBenefit.find_or_initialize_by(agreement_benefit_id: option[0], benefit_id: benefit.id)
  prod_ben.coverage_amount = option[2]
  prod_ben.premium = option[3]
  puts "#{prod_ben.agreement_benefit.name}(#{prod_ben.benefit.name}) - Done" if prod_ben.save!
end

# Department.create!(name: 'Underwriting')
# # # # # Coop User
# Employee.create!(first_name: 'Cherry', last_name: 'Gonzales', middle_name: 'P', birthdate: FFaker::Time.date, mobile_number: '09948423385', department_id: 1)
# User.create!(email: 'analyst@gmail.com', password: 'password', password_confirmation: 'password',  approved: true, userable_id: 1, userable_type: 'Employee')


# # # [
# # #     #spouse option 1
# # #     [, "Life Insurance", 50000, 240],
# # #     [23, "Accidental Death & Dismemberment", 50000, 240],
# # #     [23, "Burial Benefit(Natural)", 5000, 25],
# # #     #spouse option 2
# # #     [27, "Life Insurance", 200000, 955],
# # #     [27, "Accidental Death & Dismemberment", 200000, 955],
# # #     [27, "Burial Benefit(Natural)", 20000, 100],
# # #     #spouse option 3
# # #     [28, "Life Insurance", 400000, 1875],
# # #     [28, "Accidental Death & Dismemberment", 400000, 1875],
# # #     [28, "Burial Benefit(Natural)", 20000, 100],
# # #     #parent option 1
# # #     [24, "Life Insurance", 50000, 240],
# # #     [24, "Accidental Death & Dismemberment", 50000, 240],
# # #     [24, "Burial Benefit(Natural)", 5000, 25],
# # #     #parent option 2
# # #     [29, "Life Insurance", 200000, 955],
# # #     [29, "Accidental Death & Dismemberment", 200000, 955],
# # #     [29, "Burial Benefit(Natural)", 20000, 100],
# # #     #parent option 3
# # #     [30, "Life Insurance", 400000, 1875],
# # #     [30, "Accidental Death & Dismemberment", 400000, 1875],
# # #     [30, "Burial Benefit(Natural)", 20000, 100],
# # #     #child option 1
# # #     [25, "Life Insurance", 50000, 60],
# # #     [25, "Accidental Death & Dismemberment", 50000, 60],
# # #     [25, "Burial Benefit(Natural)", 5000, 25],
# # #     #child option 2
# # #     [31, "Life Insurance", 200000, 235],
# # #     [31, "Accidental Death & Dismemberment", 200000, 235],
# # #     [31, "Burial Benefit(Natural)", 20000, 100],
# # #     #child option 3
# # #     [32, "Life Insurance", 400000, 497.5],
# # #     [32, "Accidental Death & Dismemberment", 400000, 497.5],
# # #     [32, "Burial Benefit(Natural)", 20000, 100],
# # #     #sibling option 1
# # #     [26, "Life Insurance", 50000, 60],
# # #     [26, "Accidental Death & Dismemberment", 50000, 60],
# # #     [26, "Burial Benefit(Natural)", 5000, 25],
# # #     #sibling option 2
# # #     [33, "Life Insurance", 200000, 235],
# # #     [33, "Accidental Death & Dismemberment", 200000, 235],
# # #     [33, "Burial Benefit(Natural)", 20000, 100],
# # #     #sibling option 3
# # #     [34, "Life Insurance", 400000, 497.5],
# # #     [34, "Accidental Death & Dismemberment", 400000, 497.5],
# # #     [34, "Burial Benefit(Natural)", 20000, 100],
# # #   ].each do |option|
# # #     benefit = Benefit.find_by(name: option[1])
# # #     prod_ben = ProductBenefit.find_or_initialize_by(agreement_benefit_id: option[0], benefit_id: benefit.id)
# # #     prod_ben.coverage_amount = option[2]
# # #     prod_ben.premium = option[3]
# # #     puts "#{prod_ben.agreement_benefit.name}(#{prod_ben.benefit.name}) - Done" if prod_ben.save!
# end


# (1524..1710).each do |num|
#   gr = GroupRemit.find(5)

#   batch = Batch.find(num)

#   bgr = BatchGroupRemit.find_or_initialize_by(batch: batch, group_remit: gr)
#   puts "#{bgr.batch_id} - #{bgr.group_remit_id}" if bgr.save!
# end

# Authority Level
# [
#   ["Level 1", 50000],
#   ["Level 2", 100000],
#   ["Level 3", 150000],
#   ["Level 4", 250000],
#   ["Level 5", 500000],
#   ["Level 6", 1000000],
#   ["Level 7", 2000000],
#   ["Level 8", 5000000]
# ].each do |level|
#   al = AuthorityLevel.find_or_initialize_by(name: level[0])
#   al.maxAmount = level[1]
#   puts "#{al.name} - Saved!" if al.save!
# end

# spreadsheet = Roo::Spreadsheet.open("/Users/jaysonregalario/Downloads/Book1.xlsx")
# (3..spreadsheet.last_row).each do |row|
#   user = User.find_by(id: spreadsheet.cell(row, "A"))

#   level = case spreadsheet.cell(row, "D")
#   when "Head" then AuthorityLevel.find_by(name: "Level 6")
#   when "VP" then AuthorityLevel.find_by(name: "Level 8")
#   else
#     AuthorityLevel.find_by(name: spreadsheet.cell(row, "D"))
#   end

#   user_lev = UserLevel.find_or_initialize_by(user: user, authority_level: level)
#   user_lev.active = true
#   puts "#{user_lev.user.email}(#{user_lev.authority_level.maxAmount}) - Saved!" if user_lev.save!
# end

# [
#   ["Good Samaritan Multi-Purpose Cooperaitve", "Region 2", "Isabela", "San Mateo"]
# ].each do |row|
#   coop = Cooperative.find_or_initialize_by(name: row[0])
#   coop.region = row[1]
#   coop.province = row[2]
#   coop.municipality = row[3]

#   puts "#{coop.name} - Saved!" if coop.save!
# end

# [
#   ["Good Samaritan Multi-Purpose Cooperaitve", 1, 1, 50000, "Single", 18, 65, 65, 0, 0, 835]
# ].each do |row|
#   coop = Cooperative.find_by(name: row[0])

#   agree = Agreement.find_or_initialize_by(cooperative: coop, plan_id: row[1])
#   agree.agent_id = row[2]
#   agree.nel = row[3]
#   agree.anniversary_type = row[4]
#   agree.entry_age_from = row[5]
#   agree.entry_age_to = row[6]
#   agree.exit_age = row[7]
#   agree.coop_sf = row[8]
#   agree.agent_sf = row[9]
#   agree.minimum_participation = row[10]
#   agree.moa_no = "MOA-#{sprintf '%05d', coop.id}"
#   agree.proposal_id = 1

#   puts "#{agree.cooperative.name}(#{agree.moa_no}) - Saved!" if agree.save!
# end


# [
#   ["Principal", 1, 18, 65]
# ].each do |row|
  
#   agree = Agreement.find(18)
  
#   ab = AgreementBenefit.find_or_initialize_by(agreement: agree, insured_type: row[1], name: row[0])
#   ab.proposal_id = 1
#   ab.min_age = row[2]
#   ab.max_age = row[3]

#   puts "#{ab.name} - Saved!" if ab.save!
# end

# [
#   #[AB Id, benefit id, amount, premium]
#   [77, 1, 55000, 225],
#   [77, 13, 55000, 225]
# ].each do |row|
#   ab = AgreementBenefit.find(row[0])
#   ben = Benefit.find(row[1])

#   pb = ProductBenefit.find_or_initialize_by(agreement_benefit: ab, benefit: ben)
#   pb.coverage_amount = row[2]
#   pb.premium = row[3]

#   puts "#{pb.agreement_benefit.name}(#{pb.benefit.name}-#{pb.coverage_amount}) -- Saved!" if pb.save!
# end

agree = Agreement.find(18)
anniv = Anniversary.find_or_initialize_by(agreement: agree)
anniv.name = "June 25"
anniv.anniversary_date = "2023-05-25"
puts "#{anniv.agreement.moa_no} (#{anniv.name}) - Saved!" if anniv.save!