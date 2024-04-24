# spec/factories/treasury_accounts.rb
FactoryBot.define do
  factory :treasury_account, class: 'Treasury::Account' do
    name { FFaker::Name.name }
    account_type { FFaker::Random.rand(1..6) }
    is_check_account { FFaker::Boolean.random }
    contact_number { FFaker::PhoneNumber.phone_number }
    address { FFaker::Address.street_address }
    created_at { Time.now }
    updated_at { Time.now }
    code { FFaker::Lorem.word }
    account_category { FFaker::Random.rand(0..2) }
    account_number { FFaker::BankUS.account_number }
  end
end
