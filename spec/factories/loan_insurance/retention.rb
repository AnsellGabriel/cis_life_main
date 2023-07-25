FactoryBot.define do
  factory :retention, class: 'LoanInsurance::Retention' do
    amount { 500_000 }
    active { false }
    date_actived { nil }
    date_deactived { nil }
  end
end