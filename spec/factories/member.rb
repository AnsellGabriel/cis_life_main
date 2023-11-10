FactoryBot.define do
  factory :member do
    last_name { FFaker::Name.last_name }
    first_name { FFaker::Name.first_name }
    middle_name { FFaker::Name.last_name }
    suffix { FFaker::Name.suffix }
    email { FFaker::Internet.email }
    mobile_number { "+639568735112" }
    birth_date { FFaker::Time.between(60.years.ago, 18.years.ago) }
    birth_place { FFaker::Address.city }
    address { FFaker::Address.street_address }
    civil_status { "Single" }
    gender {"male"}
  end
end
