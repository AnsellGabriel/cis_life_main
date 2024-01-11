FactoryBot.define do
  factory :agreement do
    cooperative
    agent
    association :plan, factory: :plan_lppi

    moa_no { "MOA-#{FFaker::Vehicle.vin}" }
    nel { 25000.00 }
    coop_sf { 10 }
    agent_sf { 5 }
    minimum_participation { 100 }
    contestability { 12 }
    nml { 1000000.00 }
    entry_age_from { 18 }
    entry_age_to { 65 }
    exit_age { 70 }
  end
end
