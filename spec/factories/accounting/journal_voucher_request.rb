FactoryBot.define do
  factory :journal_voucher_request, class: 'Accounting::JournalVoucherRequest' do
    association :requestable, factory: :cooperative
    amount { FFaker::Random.rand(100..1000).round(2) }
    status { 0 }
    particulars { FFaker::Lorem.sentence }
  end
end
