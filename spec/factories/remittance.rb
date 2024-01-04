FactoryBot.define do
  factory :remittance do
    name { FFaker::Name.name }
    effectivity_date { '2024/01/01' }
    expiry_date { '2024/12/31' }
    terms { rand 0..13 }
    status { 3 }
    gross_premium { 1000 }
    coop_commission { 100 }
    agent_commission { 50 }
    net_premium { 850 }
    type { 'Remittance' }
    date_submitted { '2024/01/01' }

    association :agreement, factory: :agreement
  end
end
