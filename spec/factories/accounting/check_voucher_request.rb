FactoryBot.define do
  factory :check_voucher_request, class: 'Accounting::CheckVoucherRequest' do
    association :requestable, factory: :cooperative
    amount { FFaker::Random.rand(100..1000).round(2) }
    status { 0 }
    analyst { FFaker::Name.name }
    description { FFaker::Lorem.sentence }
    payment_type { FFaker::Random.rand(0..1) }
    payout_type { FFaker::Random.rand(0..1) }
    bank_id { FFaker::Random.rand(1..1000) }
  end
end
