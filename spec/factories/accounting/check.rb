FactoryBot.define do
  factory :check_voucher, class: 'Accounting::Check' do
    date_voucher { "2019-01-01" }
    particulars { FFaker::Lorem.word }
    voucher { FFaker.numerify('####') }
    amount { 1000 }
    status { 0 }
    claimable { false }
    type { "Accounting::Check" }

    association :payable, factory: :cooperative
    association :treasury_account, factory: :account
  end
end
