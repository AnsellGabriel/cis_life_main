FactoryBot.define do
  factory :batch_remit, class: 'LoanInsurance::BatchRemit' do
    agreement

    name { "Batch Remit #{FFaker::Vehicle.vin}" }
    effectivity_date { Date.today }
    expiry_date { Date.today + 1.year }
    terms { 12 }
    status { 0 }
    type { 'LoanInsurance::BatchRemit' }
  end
end