FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { 'password' }
    approved { true }
    association :userable, factory: :coop_user
  end

  factory :coop_user do
    cooperative
    coop_branch

    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    middle_name { FFaker::Name.last_name }
    birthdate { Date.today - 19.years }
  end

  factory :agent do
    agent_group

    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    middle_name { FFaker::Name.last_name }
  end

  factory :agent_group do
    name { 'Marketing Division'}
  end
end