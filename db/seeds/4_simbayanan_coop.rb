# agent = Agent.find(1)

# coop = Cooperative.find_by(name: "SIMBAYANAN NI MARIA MULTIPURPOSE COOPERATIVE")
# main_branch = coop.coop_branches.find_by(name: 'Main')
# coop_user = CoopUser.create!(cooperative: coop, coop_branch: main_branch, first_name: 'Rullian', middle_name: 'Postrano', last_name: 'Rong', birthdate: '1996-09-03')
# User.create!(email: 'simbayanan@gmail.com', password: 'Password123!', userable: coop_user, approved: 1)

# puts 'SIMBAYANAN user created'

# plan = Plan.find_by(acronym: 'GYRTFR')

# agreement = Agreement.create!(cooperative: coop, plan: plan, agent: agent, moa_no: 'SIMBAYANAN GYRT', anniversary_type: 'single', nel: 25000, nml: 500000, entry_age_from: 18, entry_age_to: 65, exit_age: 71.5, coop_sf: 15, agent_sf: 10, minimum_participation: 10_000, contestability: 12)

# Anniversary.create!(name: "Nov 15", agreement: agreement, anniversary_date: '2024-11-15')

# life_benefit = Benefit.find_by(name: 'Life')
# amr_benefit = Benefit.find_by(name: 'Accidental Medical Reimbursement')
# burial_benefit = Benefit.find_by(name: 'Burial')

# [
#   {
#     name: "Principal",
#     with_dependent: true,
#     coverage_amount: 100_000,
#     burial_coverage_amount: 5_000,
#     amr_amount: 2_000,
#     premium: 330,
#     min_age: 18,
#     max_age: 69,
#     exit_age: 80.5,
#     insured_type: 9
#   },
#   {
#     name: "Overage",
#     with_dependent: false,
#     coverage_amount: 100_000,
#     burial_coverage_amount: 5_000,
#     premium: 330,
#     min_age: 72,
#     max_age: 80,
#     exit_age: 80.5,
#     insured_type: 8
#   },
#   {
#     name: "Spouse",
#     with_dependent: false,
#     coverage_amount: 30_000,
#     premium: 180,
#     min_age: 18,
#     max_age: 65,
#     exit_age: 66.5,
#     insured_type: 2
#   },
#   {
#     name: "Parent",
#     with_dependent: false,
#     coverage_amount: 30_000,
#     premium: 180,
#     min_age: 18,
#     max_age: 65,
#     exit_age: 66.6,
#     insured_type: 3
#   },
#   {
#     name: "Child",
#     with_dependent: false,
#     coverage_amount: 30_000,
#     premium: 50,
#     min_age: 0,
#     max_age: 21,
#     exit_age: 21.5,
#     insured_type: 4
#   },
#   {
#     name: "Sibling",
#     with_dependent: false,
#     coverage_amount: 30_000,
#     premium: 50,
#     min_age: 0,
#     max_age: 21,
#     exit_age: 21.5,
#     insured_type: 5
#   }
# ].each do |option|
#   ab = AgreementBenefit.create!(name: option[:name], min_age: option[:min_age], max_age: option[:max_age], exit_age: option[:exit_age], insured_type: option[:insured_type], agreement: agreement, with_dependent: option[:with_dependent])

#   puts "#{ab.name} added"

#   ProductBenefit.create!(benefit: life_benefit, agreement_benefit: ab, coverage_amount: option[:coverage_amount], premium: option[:premium])

#   if option[:name] == 'Principal' || option[:name] == 'Overage'
#     ProductBenefit.create!(benefit: burial_benefit, agreement_benefit: ab, coverage_amount: option[:burial_coverage_amount])
#   end

#   if option[:name] == 'Principal'
#     ProductBenefit.create!(benefit: amr_benefit, agreement_benefit: ab, coverage_amount: option[:amr_amount])
#   end

#   puts "#{ab.name} benefits added"
# end
