FactoryBot.define do
  factory :rate, class: 'LoanInsurance::Rate' do
    agreement
    
    min_age { rand(18..20) }
    max_age { rand(21..60) }
    monthly_rate { rand(1..5) }
    annual_rate { monthly_rate * 12 }
    daily_rate { annual_rate / 365 }
  end
end