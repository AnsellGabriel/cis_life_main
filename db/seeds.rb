# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Admin
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# Cooperative
cooperatives_spreadsheet = Roo::Spreadsheet.open("/Users/macbookair/Desktop/cis_data/Operating-Coops.xlsx")
(5..100).each do |row|
    spreadsheet = cooperatives_spreadsheet
    Cooperative.find_or_create_by!(
        registration_number: spreadsheet.cell(row, 'A'), 
        name: spreadsheet.cell(row, 'B'), 
        region: spreadsheet.cell(row, 'C'), 
        province: spreadsheet.cell(row, 'D'), 
        municipality: spreadsheet.cell(row, 'E'), 
        street: spreadsheet.cell(row, 'F'), 
        cooperative_type: spreadsheet.cell(row, 'H'),
        email: spreadsheet.cell(row, 'K'), 
        contact_number: spreadsheet.cell(row, 'J'),
    )
end

# Proposal
Proposal.create!(cooperative_id: 1, coop_sf: 12.5, agent_sf: 4.5, ave_age: 50, minimum_participation: 3)

# AgentGroup
AgentGroup.create!(name: 'Marketing', description: 'Marketing Group')

# Agent
Agent.create!(first_name: 'Rullian', middle_name: 'Postrano', last_name: 'Rong', agent_group_id: 1)

# Plan
Plan.create!(name: 'GYRT-Basic', description: 'Plan 1 description', gyrt_type: 'basic', acronym: 'GYRT')
Plan.create!(name: 'GYRT-Family', description: 'Plan 2 description', gyrt_type: 'family', acronym: 'GYRTF')
Plan.create!(name: 'GYRT-Basic Ranking', description: 'Plan 3 description', gyrt_type: 'basic', acronym: 'GYRTBR')
Plan.create!(name: 'GYRT-Family Ranking', description: 'Plan 4 description', gyrt_type: 'family', acronym: 'GYRTFR')


# Benefit
Benefit.create!(name: 'Life', description: 'Benefit 1 description', abbreviation: 'LIFE')
Benefit.create!(name: 'Accidental Death & Dismemberment', description: 'Benefit 2 description', abbreviation: 'ADD')


# GYRT Basic Single Anniversary  
Agreement.create!(proposal_id: 1, name: 'Basic Single Anniv', description: 'Agreement with a single anniversary type', plan_id: 1, agent_id: 1, cooperative_id: 1, anniversary_type: 'single')
AgreementBenefit.create!(agreement_id: 1, proposal_id: 1, name: 'Agreement Benefit principal', min_age: 18, max_age: 65, insured_type: 1)
ProductBenefit.create!(coverage_amount: 150000,benefit_id: 1, agreement_benefit_id: 1, premium: 1000)
ProductBenefit.create!(coverage_amount: 100000,benefit_id: 2, agreement_benefit_id: 1, premium: 1000)
Anniversary.create!(agreement_id: 1, name: 'Today', anniversary_date: Date.today)

# GYRT Family Multiple Anniversary
Agreement.create!(proposal_id: 1, name: 'Family Multiple Anniv', description: 'Agreement with a mutiple anniversary type', plan_id: 2, agent_id: 1, cooperative_id: 1, anniversary_type: 'multiple')
AgreementBenefit.create!(agreement_id: 2, proposal_id: 1, name: 'Agreement Benefit principal', min_age: 18, max_age: 65, insured_type: 1)
ProductBenefit.create!(coverage_amount: 150000,benefit_id: 1, agreement_benefit_id: 2, premium: 1000)
AgreementBenefit.create!(agreement_id: 2, proposal_id: 1, name: 'Agreement Benefit dependent', min_age: 18, max_age: 65, insured_type: 2)
ProductBenefit.create!(coverage_amount: 100000,benefit_id: 2, agreement_benefit_id: 3, premium: 500)


Anniversary.create!(agreement_id: 2, name: 'April 18', anniversary_date: '2023/03/18')
Anniversary.create!(agreement_id: 2, name: 'May 31', anniversary_date: '2023/02/31')
Anniversary.create!(agreement_id: 2, name: 'June 30', anniversary_date: '2023/01/30')

# GYRT Basic No Anniversary
Agreement.create!(proposal_id: 1, name: 'Basic No Anniv', description: 'Agreement with no anniversary type', plan_id: 1, agent_id: 1, cooperative_id: 1, anniversary_type: 'none')
AgreementBenefit.create!(agreement_id: 3, proposal_id: 1, name: 'Agreement Benefit principal', min_age: 18, max_age: 65, insured_type: 1)
ProductBenefit.create!(coverage_amount: 150000,benefit_id: 1, agreement_benefit_id: 4, premium: 1000)
ProductBenefit.create!(coverage_amount: 100000,benefit_id: 2, agreement_benefit_id: 4, premium: 1000)

# GYRT Ranking - Basic
Agreement.create!(proposal_id: 1, name: 'GYRT - Basic Ranking', description: 'Agreement with ranking type', plan_id: 3, agent_id: 1, cooperative_id: 1, anniversary_type: 'single')
AgreementBenefit.create!(agreement_id: 4, proposal_id: 1, name: 'Agreement Benefit principal', min_age: 18, max_age: 65, insured_type: 3)
AgreementBenefit.create!(agreement_id: 4, proposal_id: 1, name: 'Agreement Benefit principal', min_age: 18, max_age: 65, insured_type: 4)

ProductBenefit.create!(coverage_amount: 100000,benefit_id: 1, agreement_benefit_id: 5, premium: 500)
ProductBenefit.create!(coverage_amount: 150000,benefit_id: 1, agreement_benefit_id: 6, premium: 1000)
Anniversary.create!(agreement_id: 4, name: 'April 18', anniversary_date: '2023/03/18')



# CoopBranch of Coop 1
10.times do |i|
    CoopBranch.create!(name: "Branch #{i+1}", cooperative_id: 1, region: "Region 1", province: "Province 1", municipality: "Municipality 1", barangay: "Barangay 1", street: "Street 1", contact_details: "09123456789")
end

# Coop User
CoopUser.create!(first_name: 'Lian', last_name: 'Postrano', middle_name: 'Elliot', birthdate: FFaker::Time.date, mobile_number: '09948423385', coop_branch_id: 1, cooperative_id: 1)
User.create!(email: 'coop@gmail.com', password: 'password', password_confirmation: 'password',  approved: true, userable_id: 1, userable_type: 'CoopUser')

