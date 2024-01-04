FactoryBot.define do
  factory :account, class: 'Treasury::Account' do
    name { 'Metrobank' }
    account_type { 1 }
    is_check_account { 0 }

    trait :gyrt_service_fee do
      name { 'Service Fee - GYRT' }
    end

    trait :lppi_service_fee do
      name { 'Service Fee - LPPI' }
    end

    trait :gyrt_premium_income do
      name { 'Premium Income - GYRT' }
    end

    trait :lppi_premium_income do
      name { 'Premium Income - LPPI' }
    end

  end
end
