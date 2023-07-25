FactoryBot.define do
  factory :retention, class: 'LoanInsurance::Retention' do
    amount { 500_000 }
    active { false }
    date_activated { nil }
    date_deactivated { nil }
  end
end