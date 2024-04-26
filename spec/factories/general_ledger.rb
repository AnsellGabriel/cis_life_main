FactoryBot.define do
  factory :general_ledger, class: 'GeneralLedger' do
    association :ledgerable, factory: :check_voucher
    association :account, factory: :treasury_account
    description { FFaker::Lorem.sentence }
    ledger_type { FFaker::Random.rand(0..1) }
    amount { FFaker::Random.rand(100..10_000).round(2) }
    transaction_date { FFaker::Time.date }
  end
end
