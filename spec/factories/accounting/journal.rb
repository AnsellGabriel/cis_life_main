FactoryBot.define do
  factory :journal, class: 'Accounting::Journal' do
    date_voucher { FFaker::Time.date }
    voucher { "#{FFaker::Time.date.year}-#{FFaker::Time.date.month}-001" }
    association :payable, factory: :cooperative
    particulars { FFaker::Lorem.sentence }
    status { 0 }
    audit { 0 }
    audited_by { FFaker::Random.rand(1..10) }
    post_date { FFaker::Time.date }
    accountant_id { FFaker::Random.rand(1..10) }
    approved_by { FFaker::Random.rand(1..10) }
    certified_by { FFaker::Random.rand(1..10) }
    type { "Accounting::Journal" }
    branch { FFaker::Random.rand(0..3) }
  end
end
