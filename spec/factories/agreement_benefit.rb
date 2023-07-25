FactoryBot.define do
  factory :agreement_benefit do
    agreement
    association :plan, factory: :plan_lppi

    insured_type { 1 }
    name { FFaker::Name.name }
    min_age { rand(18..20) }
    max_age { rand(21..60) }
    exit_age { rand(61..80) }
  end
end