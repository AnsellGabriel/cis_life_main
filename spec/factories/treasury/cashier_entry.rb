FactoryBot.define do
  factory :cashier_entry, class: 'Treasury::CashierEntry' do
    or_no { 12345 }
    or_date { FFaker::Time.date }
    payment_type { 1 }
    amount { 850 }
    status { 0 }

    association :entriable, factory: :payment
    association :treasury_account, factory: :account
  end
end
