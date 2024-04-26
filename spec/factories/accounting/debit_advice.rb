FactoryBot.define do
  factory :debit_advice, class: 'Accounting::DebitAdvice' do
    date_voucher { FFaker::Time.date }
    voucher { "#{FFaker::Time.date.year}-#{FFaker::Time.date.month}-001" }
    association :payable, factory: :cooperative
    association :treasury_account
    amount { FFaker::Random.rand(100..10_000).round(2) }
    particulars { FFaker::Lorem.sentence }
    status { 0 }
    audit { 0 }
    audited_by { FFaker::Random.rand(1..10) }
    post_date { FFaker::Time.date }
    accountant_id { FFaker::Random.rand(1..10) }
    approved_by { FFaker::Random.rand(1..10) }
    certified_by { FFaker::Random.rand(1..10) }
    association :check_voucher_request
    type { "Accounting::DebitAdvice" }
    branch { FFaker::Random.rand(0..3) }
  end
end
