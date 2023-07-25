FactoryBot.define do
  factory :loan, class: 'LoanInsurance::Loan' do
    cooperative

    name { FFaker::Name.name }
    description { FFaker::Lorem.sentence }
  end
end