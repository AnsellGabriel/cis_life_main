# spec/factories/coop_banks.rb
FactoryBot.define do
  factory :coop_bank do
    association :cooperative
    association :treasury_account, factory: :treasury_account
  end
end
