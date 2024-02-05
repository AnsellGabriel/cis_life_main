agent = Agent.find(1)

jfc_coop = Cooperative.find_by(name: "JOLLIBEE FOODS CORPORATION EMPLOYEES MULTIPURPOSE COOPERATIVE (JFC EMPC OR JFC COOP)")
jfc_main = jfc_coop.coop_branches.find_by(name: 'Main')
coop_user = CoopUser.create!(cooperative: jfc_coop, coop_branch: jfc_main, first_name: 'Rullian', middle_name: 'Postrano', last_name: 'Rong', birthdate: '1996-09-03')
User.create!(email: 'jfc@gmail.com', password: 'Password123!', userable: coop_user, approved: 1)

puts 'JFC user created'

jfc_plan = Plan.find_by(acronym: 'GYRTFR')

jfc_agreement = Agreement.create!(cooperative: jfc_coop, plan: jfc_plan, agent: agent, moa_no: 'JFC GYRT', anniversary_type: '12 months', nel: 25000, nml: 500000, entry_age_from: 18, entry_age_to: 65, exit_age: 80.5, coop_sf: 10, agent_sf: 10, minimum_participation: 1000, contestability: 12)

life_benefit = Benefit.find_by(name: 'Life')
add_benefit = Benefit.find_by(name: 'Accidental Death & Dismemberment')
burial_benefit = Benefit.find_by(name: 'Burial')

[
  ["Option 1", true, 50_000, 5_000, 335, 18, 65, 80.5, 9],
  ["Option 1 - Spouse", false, 50_000, 5_000, 505, 18, 65, 80.5, 2],
  ["Option 1 - Parent", false, 50_000, 5_000, 505, 18, 65, 80.5, 3],
  ["Option 1 - Child", false, 50_000, 5_000, 145, 3, 21, 80.5, 4],
  ["Option 1 - Sibling", false, 50_000, 5_000, 145, 3, 21, 80.5, 5],
  ["Option 2", true, 200_000, 20_000, 1_330, 18, 65, 80.5, 9],
  ["Option 2 - Spouse", false, 200_000, 20_000, 2_010, 18, 65, 80.5, 2],
  ["Option 2 - Parent", false, 200_000, 20_000, 2_010, 18, 65, 80.5, 3],
  ["Option 2 - Child", false, 200_000, 20_000, 570, 3, 21, 80.5, 4],
  ["Option 2 - Sibling", false, 200_000, 20_000, 570, 3, 21, 80.5, 5],
  ["Option 3", true, 400_000, 20_000, 2_550, 18, 65, 80.5, 8],
  ["Option 3 - Spouse", false, 400_000, 20_000, 3_850, 18, 65, 80.5, 2],
  ["Option 3 - Parent", false, 400_000, 20_000, 3_850, 18, 65, 80.5, 3],
  ["Option 3 - Child", false, 400_000, 20_000, 1_095, 3, 21, 80.5, 4],
  ["Option 3 - Sibling", false, 400_000, 20_000, 1_095, 3, 21, 80.5, 5],
  ["Option 4", false, 1_000_000, 20_000, 8_035, 18, 65, 80.5, 7],
  ["Option 5", false, 2_000_000, 20_000, 16_945, 18, 65, 80.5, 6]
].each do |option|
  ab = AgreementBenefit.create!(name: option[0], min_age: option[5], max_age: option[6], exit_age: option[7], insured_type: option[8], agreement: jfc_agreement, with_dependent: option[1])

  puts "#{ab.name} added"

  ProductBenefit.create!(benefit: life_benefit, agreement_benefit: ab, coverage_amount: option[2], premium: option[4])
  ProductBenefit.create!(benefit: add_benefit, agreement_benefit: ab, coverage_amount: option[2])
  ProductBenefit.create!(benefit: burial_benefit, agreement_benefit: ab, coverage_amount: option[3])

  puts "#{ab.name} benefits added"
end
