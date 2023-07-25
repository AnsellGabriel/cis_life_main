FactoryBot.define do
  factory :detail, class: 'LoanInsurance::Detail' do
    batch
    loan
    rate
    retention

    loan_amount { 250_000 }
    premium_due { 500 }
    terms { 12 }
    substandard_rate { nil}
    unuse { 10_000 }
    terminated { false }
    terminate_date { nil }
    reinsurance { false }
    date_release { FFaker::Time.date }
    date_mature { FFaker::Time.date + rand(1..12).years }

  end
end