FactoryBot.define do
  factory :group_remit, class: 'LoanInsurance::GroupRemit' do
    agreement

    name { "Group Remit #{FFaker::Vehicle.vin}" }
    status { 0 }
  end
end