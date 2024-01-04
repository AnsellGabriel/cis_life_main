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
  end
end
