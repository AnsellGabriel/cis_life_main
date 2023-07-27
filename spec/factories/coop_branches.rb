FactoryBot.define do
  factory :coop_branch do
    cooperative

    name { "Branch #{rand 1..5} " }
  end
end