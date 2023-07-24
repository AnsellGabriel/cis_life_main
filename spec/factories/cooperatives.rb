FactoryBot.define do
  factory :cooperative do
    name { FFaker::Company.name }
  end
end