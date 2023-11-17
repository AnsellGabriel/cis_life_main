FactoryBot.define do
  factory :coop_member do
    member
    cooperative
    coop_branch

    membership_date { FFaker::Time.between(5.years.ago, 1.year.ago) }
  end
end
